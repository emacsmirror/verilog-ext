;;; verilog-navigation.el --- Verilog Navigation  -*- lexical-binding: t -*-

;; Copyright (C) 2022 Gonzalo Larumbe

;; Author: Gonzalo Larumbe <gonzalomlarumbe@gmail.com>
;; URL: https://github.com/gmlarumbe/verilog-ext

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Navigation functions:
;;  - Find instances forward/backwards
;;  - Jump to definition/reference of module at point (requires gtags/xref)
;;  - Override syntax table to move forward/backwards until reaching an underscore
;;
;;; Code:


(require 'verilog-mode)
(require 'verilog-utils)
(require 'xref)
(require 'ag)
(require 'ripgrep)
(require 'projectile)
(require 'ggtags)


(defvar verilog-ext-jump-to-parent-module-engine "ag"
  "Default program to find parent module instantiations.
Either `rg' or `ag' are implemented.")


;;;; Syntax table override functions
(defun verilog-ext-forward-word (&optional arg)
  "Make verilog word navigation commands stop at underscores.
Move forward ARG words."
  (interactive "p")
  (let ((table (make-syntax-table verilog-mode-syntax-table)))
    (modify-syntax-entry ?_ "_" table)
    (with-syntax-table table
      (forward-word arg))))

(defun verilog-ext-backward-word (&optional arg)
  "Make verilog word navigation commands stop at underscores.
Move backward ARG words."
  (interactive "p")
  (let ((table (make-syntax-table verilog-mode-syntax-table)))
    (modify-syntax-entry ?_ "_" table)
    (with-syntax-table table
      (backward-word arg))))

(defun verilog-ext-electric-verilog-tab ()
  "Run `electric-verilog-tab' with original `verilog-mode' syntax table.
Prevents indentation issues with compiler directives with a modified syntax
table."
  (interactive)
  (let ((table (make-syntax-table verilog-mode-syntax-table)))
    (modify-syntax-entry ?` "w" table)
    (with-syntax-table table
      (electric-verilog-tab))))


;;;; Task/function
(defun verilog-ext-find-function-task (&optional limit bwd interactive-p)
  "Search for a Verilog function/task declaration or definition.
Allows matching of multiline declarations (such as in some UVM source files).

If executing interactively show function/task name in the minibuffer.

Updates `match-data' so that the function can be used in other contexts:
- (match-string 0) = Whole function/task regexp (until semicolon)
- (match-string 1) = Function/task name
- (match-string 2) = Class modifier (if defined externally)
- (match-string 3) = Function return type (if applicable)

Bound search to LIMIT in case optional argument is non-nil.

Search bacwards if BWD is non-nil.

Third arg INTERACTIVE-P specifies whether function call should be treated as if
it was interactive.  This changes the position where point will be at the end of
the function call."
  (let ((case-fold-search verilog-case-fold)
        (tf-re "\\<\\(function\\|task\\)\\>")
        (tf-modifiers-re "\\<\\(extern\\|static\\|pure\\|virtual\\|local\\|protected\\)\\>")
        tf-type tf-kwd-pos-end
        tf-name tf-name-pos-beg tf-name-pos-end tf-beg-of-statement-pos tf-end-of-statement-pos tf-modifiers
        func-return-type func-return-type-pos-beg func-return-type-pos-end
        class-name class-beg-pos class-end-pos
        found)
    (save-excursion
      (save-match-data
        (and (if bwd
                 (verilog-re-search-backward tf-re limit 'move)
               (verilog-re-search-forward tf-re limit 'move))
             (setq tf-type (match-string-no-properties 0))
             (setq tf-kwd-pos-end (match-end 0))
             (verilog-re-search-forward ";" limit 'move)
             (setq tf-end-of-statement-pos (point))
             (verilog-ext-backward-char)
             (verilog-ext-backward-syntactic-ws)
             (when-t (eq (preceding-char) ?\))
               (verilog-ext-backward-sexp))
             (backward-word)
             ;; Func/task name
             (when (looking-at verilog-identifier-re)
               (setq tf-name (match-string-no-properties 0))
               (setq tf-name-pos-beg (match-beginning 0))
               (setq tf-name-pos-end (match-end 0))
               (setq found t))
             ;; Externally defined functions
             (when-t (eq (preceding-char) ?:)
               (skip-chars-backward ":")
               (backward-word)
               (when (looking-at verilog-identifier-re)
                 (setq class-name (match-string-no-properties 0))
                 (setq class-beg-pos (match-beginning 0))
                 (setq class-end-pos (match-end 0))))
             ;; Automatic kwd and function return value
             (when-t (string= tf-type "function")
               (verilog-ext-backward-syntactic-ws)
               (setq func-return-type-pos-end (point))
               (goto-char tf-kwd-pos-end)
               (verilog-ext-forward-syntactic-ws)
               (when (looking-at "\\<automatic\\>")
                 (forward-word)
                 (verilog-ext-forward-syntactic-ws))
               (setq func-return-type-pos-beg (point))
               (setq func-return-type (buffer-substring-no-properties func-return-type-pos-beg
                                                                      func-return-type-pos-end)))
             ;; Func/task modifiers
             (setq tf-beg-of-statement-pos (verilog-pos-at-beg-of-statement))
             (while (verilog-re-search-backward tf-modifiers-re tf-beg-of-statement-pos 'move)
               (push (match-string-no-properties 0) tf-modifiers)))))
    (if found
        (progn
          (set-match-data (list tf-beg-of-statement-pos
                                tf-end-of-statement-pos
                                tf-name-pos-beg
                                tf-name-pos-end
                                class-beg-pos
                                class-end-pos
                                func-return-type-pos-beg
                                func-return-type-pos-end))
          (when interactive-p
            (message "%s" tf-name))
          (if bwd
              (goto-char tf-beg-of-statement-pos)
            (goto-char tf-name-pos-beg))
          (list tf-name-pos-beg tf-name tf-modifiers func-return-type class-name))
      (when interactive-p
        (if bwd
            (message "Could not find any function/task backward")
          (message "Could not find any function/task forward"))))))

(defun verilog-ext-find-function-task-fwd (&optional limit)
  "Search forward for a Verilog function/task declaration or definition.
Bound search to LIMIT in case optional argument is non-nil."
  (interactive)
  (let ((interactive-p (called-interactively-p 'interactive)))
    (verilog-ext-find-function-task limit nil interactive-p)))

(defun verilog-ext-find-function-task-bwd (&optional limit)
  "Search backward for a Verilog function/task declaration or definition.
Bound search to LIMIT in case optional argument is non-nil."
  (interactive)
  (let ((interactive-p (called-interactively-p 'interactive)))
    (verilog-ext-find-function-task limit :bwd interactive-p)))


;;;; Module/instance
(defun verilog-ext-find-module-instance-fwd (&optional limit)
  "Search forwards for a Verilog module/instance.

If executing interactively place cursor at the beginning of the module name and
show module and instance names in the minibuffer.

If executing programatically move to the end of the module and return point
position.

Updates `match-data' so that the function can be used in other contexts:
- (match-string 0) = Whole module instantiation: from beg of module name to ;
- (match-string 1) = Module name
- (match-string 2) = Instance name

Bound search to LIMIT in case optional argument is non-nil."
  (interactive)
  (let ((case-fold-search verilog-case-fold)
        (identifier-re (concat "\\(" verilog-identifier-sym-re "\\)"))
        (module-end (make-marker))
        module-name module-pos module-match-data
        instance-name instance-match-data
        pos found)
    ;; Limit the search to files that can instantiate blocks (modules/interfaces)
    (if (not (verilog-ext-scan-buffer-modules))
        (when (called-interactively-p 'interactive)
          (user-error "Not inside a module/interface file"))
      ;; Else do the search
      (save-excursion
        (save-match-data
          (when (called-interactively-p 'interactive)
            (forward-char)) ; Avoid getting stuck if executing interactively
          (while (and (not (eobp))
                      (when-t limit
                        (> limit (point)))
                      (not (and (verilog-re-search-forward (concat "\\s-*" identifier-re) limit 'move) ; Module name
                                (not (verilog-parenthesis-depth)) ; Optimize search by avoiding looking for identifiers in parenthesized expressions
                                (unless (member (match-string-no-properties 1) verilog-keywords)
                                  (setq module-name (match-string-no-properties 1))
                                  (setq module-pos (match-beginning 1))
                                  (setq module-match-data (match-data)))
                                (verilog-ext-forward-syntactic-ws)
                                (when-t (= (following-char) ?\#)
                                  (and (verilog-ext-forward-char)
                                       (verilog-ext-forward-syntactic-ws)
                                       (= (following-char) ?\()
                                       (verilog-ext-forward-sexp)
                                       (= (preceding-char) ?\))
                                       (verilog-ext-forward-syntactic-ws)))
                                (looking-at identifier-re) ; Instance name
                                (unless (member (match-string-no-properties 1) verilog-keywords)
                                  (setq instance-name (match-string-no-properties 1))
                                  (setq instance-match-data (match-data)))
                                (verilog-ext-skip-identifier-forward)
                                (verilog-ext-forward-syntactic-ws)
                                (when-t (= (following-char) ?\[)
                                  (and (verilog-ext-forward-sexp)
                                       (= (preceding-char) ?\])
                                       (verilog-ext-forward-syntactic-ws)))
                                (= (following-char) ?\()
                                (verilog-ext-forward-sexp)
                                (= (preceding-char) ?\))
                                (verilog-ext-forward-syntactic-ws)
                                (= (following-char) ?\;)
                                (set-marker module-end (1+ (point)))
                                (setq found t)
                                (if (called-interactively-p 'interactive)
                                    (progn
                                      (setq pos module-pos)
                                      (message "%s : %s" module-name instance-name))
                                  (setq pos (point))))))
            (if (verilog-parenthesis-depth)
                (verilog-backward-up-list -1)
              (forward-line)))))
      (if found
          (progn
            (set-match-data (list (nth 0 module-match-data)
                                  module-end
                                  (nth 2 module-match-data)
                                  (nth 3 module-match-data)
                                  (nth 2 instance-match-data)
                                  (nth 3 instance-match-data)))
            (goto-char pos)
            (if (called-interactively-p 'interactive)
                (message "%s : %s" module-name instance-name)
              (point)))
        (when (called-interactively-p 'interactive)
          (message "Could not find any instance forward"))))))

(defun verilog-ext-find-module-instance-bwd (&optional limit)
  "Search backwards for a Verilog module/instance.

If executing interactively place cursor at the beginning of the module name and
show module and instance names in the minibuffer.

If executing programatically move to the beginning of the module and return
point position.

Updates `match-data' so that the function can be used in other contexts:
- (match-string 0) = Whole module instantiation: from beg of module name to ;
- (match-string 1) = Module name
- (match-string 2) = Instance name

Bound search to LIMIT in case it is non-nil."
  (interactive)
  (let ((case-fold-search verilog-case-fold)
        (identifier-re (concat "\\(" verilog-identifier-sym-re "\\)"))
        (module-end (make-marker))
        module-name module-pos module-match-data
        instance-name instance-match-data
        pos found)
    ;; Limit the search to files that can instantiate blocks (modules/interfaces)
    (if (not (verilog-ext-scan-buffer-modules))
        (when (called-interactively-p 'interactive)
          (user-error "Not inside a module/interface file"))
      ;; Else do the search
      (save-excursion
        (save-match-data
          (while (and (not (bobp))
                      (when-t limit
                        (< limit (point)))
                      (not (and (set-marker module-end (verilog-re-search-backward ";" limit 'move))
                                (not (verilog-parenthesis-depth))
                                (verilog-ext-backward-syntactic-ws)
                                (= (preceding-char) ?\))
                                (verilog-ext-backward-sexp)
                                (= (following-char) ?\()
                                (verilog-ext-backward-syntactic-ws)
                                (when-t (= (preceding-char) ?\])
                                  (and (verilog-ext-backward-sexp)
                                       (= (following-char) ?\[)
                                       (verilog-ext-backward-syntactic-ws)))
                                (verilog-ext-skip-identifier-backwards)
                                (looking-at identifier-re)
                                (unless (member (match-string-no-properties 1) verilog-keywords)
                                  (setq instance-name (match-string-no-properties 1))
                                  (setq instance-match-data (match-data)))
                                (verilog-ext-backward-syntactic-ws)
                                (when-t (= (preceding-char) ?\))
                                  (and (verilog-ext-backward-sexp)
                                       (= (following-char) ?\()
                                       (verilog-ext-backward-syntactic-ws)
                                       (= (preceding-char) ?\#)
                                       (verilog-ext-backward-char)
                                       (verilog-ext-backward-syntactic-ws)))
                                (verilog-ext-skip-identifier-backwards)
                                (looking-at identifier-re)
                                (unless (member (match-string-no-properties 1) verilog-keywords)
                                  (setq module-name (match-string-no-properties 1))
                                  (setq module-pos (match-beginning 1))
                                  (setq module-match-data (match-data)))
                                (setq found t)
                                (if (called-interactively-p 'interactive)
                                    (setq pos module-pos)
                                  (setq pos (point))))))
            (if (verilog-parenthesis-depth)
                (verilog-backward-up-list 1)
              (beginning-of-line)))))
      (if found
          (progn
            (set-match-data (list (nth 0 module-match-data)
                                  module-end
                                  (nth 2 module-match-data)
                                  (nth 3 module-match-data)
                                  (nth 2 instance-match-data)
                                  (nth 3 instance-match-data)))
            (goto-char pos)
            (if (called-interactively-p 'interactive)
                (message "%s : %s" module-name instance-name)
              (point)))
        (when (called-interactively-p 'interactive)
          (message "Could not find any instance backwards"))))))

(defun verilog-ext-instance-at-point ()
  "Return list with module and instance names if point is at an instance."
  (let ((point-cur (point))
        point-instance-begin point-instance-end instance-type instance-name)
    (save-excursion
      (when (and (verilog-re-search-forward ";" nil t)
                 (verilog-ext-find-module-instance-bwd)) ; Sets match data
        (setq instance-type (match-string-no-properties 1))
        (setq instance-name (match-string-no-properties 2))
        (setq point-instance-begin (match-beginning 0))
        (setq point-instance-end   (match-end 0))
        (if (and (>= point-cur point-instance-begin)
                 (<= point-cur point-instance-end))
            (list instance-type instance-name)
          nil)))))

(defun verilog-ext-find-module-instance-bwd-2 ()
  "Search backwards for a Verilog module/instance.
The difference with `verilog-ext-find-module-instance-bwd' is that it
moves the cursor to current instance if pointing at one."
  (interactive)
  (let (inside-instance-p)
    (save-excursion
      (backward-char)
      (when (verilog-ext-instance-at-point)
        (setq inside-instance-p t)))
    (if inside-instance-p
        (progn
          (goto-char (match-beginning 1))
          (message "%s : %s" (match-string-no-properties 1) (match-string-no-properties 2)))
      (call-interactively #'verilog-ext-find-module-instance-bwd))))

(defun verilog-ext-jump-to-module-at-point (&optional ref)
  "Jump to definition of module at point.
If REF is non-nil show references instead."
  (interactive)
  (unless (executable-find "global")
    (error "Couldn't find executable `global' in PATH"))
  (unless (member 'ggtags--xref-backend xref-backend-functions)
    (error "Error: ggtags not configured as an xref backend.  Is ggtags-mode enabled?"))
  (unless ggtags-project-root
    (error "Error: `ggtags-project-root' not set.  Are GTAGS/GRTAGS/GPATH files created?"))
  (let ((module (car (verilog-ext-instance-at-point))))
    (if module
        (progn
          (if ref
              (xref-find-references module)
            (xref-find-definitions module))
          module) ; Report module name
      (user-error "Not inside a Verilog instance"))))

(defun verilog-ext-jump-to-module-at-point-def ()
  "Jump to definition of module at point."
  (interactive)
  (verilog-ext-jump-to-module-at-point))

(defun verilog-ext-jump-to-module-at-point-ref ()
  "Show references of module at point."
  (interactive)
  (verilog-ext-jump-to-module-at-point :ref))


;;;; Jump to parent module
(defvar verilog-ext-jump-to-parent-module-point-marker nil
  "Point marker to save the state of the buffer where the search was started.
Used in ag/rg end of search hooks to conditionally set the xref marker stack.")
(defvar verilog-ext-jump-to-parent-module-name nil)
(defvar verilog-ext-jump-to-parent-module-dir nil)

(defun verilog-ext-jump-to-parent-module ()
  "Find current module/interface instantiations via `ag'/`rg'.
Configuration should be done so that `verilog-ext-navigation-ag-rg-hook' is run
after the search has been done."
  (interactive)
  (let* ((proj-dir (or (when (featurep 'projectile)
                         (projectile-project-root))
                       (when (featurep 'ggtags)
                         ggtags-project-root)
                       default-directory))
         (module-name (or (verilog-ext-select-file-module buffer-file-name)
                          (error "No module/interface found @ %s" buffer-file-name)))
         (module-instance-pcre ; Many thanks to Kaushal Modi for this PCRE
          (concat "^\\s*\\K"                          ; Initial blank before module name. Do not highlighting anything till the name
                  "\\b(" module-name ")\\b"           ; Module name identifier
                  "(?="                             ; Lookahead to avoid matching
                  "(\\s+|("                          ; Either one or more spaces before the instance name, or...
                  "(\\s*\#\\s*\\((\\n|.)*?\\))+"           ; ... hardware parameters, '(\n|.)*?' does non-greedy multi-line grep
                  "(\\n|.)*?"                        ; Optional newline/space before instance name/first port name
                  "([^.])*?"                        ; Do not match more than 1 ".PARAM (PARAM_VAL),"
                  "))"                              ; Close capture groups before matching identifier
                  "\\b(" verilog-identifier-re ")\\b" ; Instance name
                  "(?=[^a-zA-Z0-9_]*\\()"             ; Nested lookahead (space/newline after instance name and before opening parenthesis)
                  ")")))                            ; Closing lookahead
    ;; Update variables used by the ag/rg search finished hooks
    (setq verilog-ext-jump-to-parent-module-name module-name)
    (setq verilog-ext-jump-to-parent-module-dir proj-dir)
    ;; Perform project based search
    (cond
     ;; Try ripgrep
     ((and (string= verilog-ext-jump-to-parent-module-engine "rg")
           (executable-find "rg"))
      (let ((rg-extra-args '("-t" "verilog" "--pcre2" "--multiline" "--stats")))
        (ripgrep-regexp module-instance-pcre proj-dir rg-extra-args)
        (setq verilog-ext-jump-to-parent-module-point-marker (point-marker))))
     ;; Try ag
     ((and (string= verilog-ext-jump-to-parent-module-engine "ag")
           (executable-find "ag"))
      (let ((ag-arguments ag-arguments)
            (extra-ag-args '("--verilog" "--stats")))
        (dolist (extra-ag-arg extra-ag-args)
          (add-to-list 'ag-arguments extra-ag-arg :append))
        (ag-regexp module-instance-pcre proj-dir)
        (setq verilog-ext-jump-to-parent-module-point-marker (point-marker))))
     ;; Fallback
     (t
      (error "Did not find `rg' nor `ag' in $PATH")))))

(defun verilog-ext-navigation-ag-rg-hook ()
  "Jump to the first result and push xref marker if there were any matches.
Kill the buffer if there is only one match."
  (let ((module-name (propertize verilog-ext-jump-to-parent-module-name 'face '(:foreground "green")))
        (dir (propertize verilog-ext-jump-to-parent-module-dir 'face '(:foreground "light blue")))
        (num-matches))
    (save-excursion
      (goto-char (point-min))
      (re-search-forward "^\\([0-9]+\\) matches\\s-*$" nil :noerror)
      (setq num-matches (string-to-number (match-string-no-properties 1))))
    (cond ((eq num-matches 1)
           (xref-push-marker-stack verilog-ext-jump-to-parent-module-point-marker)
           (next-error)
           (kill-buffer (current-buffer))
           (message "Jump to only match for [%s] @ %s" module-name dir))
          ((> num-matches 1)
           (xref-push-marker-stack verilog-ext-jump-to-parent-module-point-marker)
           (next-error)
           (message "Showing matches for [%s] @ %s" module-name dir))
          (t
           (kill-buffer (current-buffer))
           (message "No matches found")))))

;;; Hooks
(defun verilog-ext-navigation-hook ()
  "Verilog-ext navigation hook."
  ;; Avoid considering tick as part of a symbol on preprocessor directives while
  ;; isearching.  Works in conjunction with `verilog-ext-electric-verilog-tab'
  ;; to get back standard table to avoid indentation issues with compiler directives.
  (modify-syntax-entry ?` "."))


;;; Dwim
(defun verilog-ext-nav-down-dwim ()
  "Context based search downwards.
If in a module/interface look for instantiations.
Otherwise look for functions/tasks."
  (interactive)
  (cond ((verilog-ext-scan-buffer-modules)
         (call-interactively #'verilog-ext-find-module-instance-fwd))
        (t
         (call-interactively #'verilog-ext-find-function-task-fwd))))

(defun verilog-ext-nav-up-dwim ()
  "Context based search upwards.
If in a module/interface look for instantiations.
Otherwise look for functions/tasks."
  (interactive)
  (cond ((verilog-ext-scan-buffer-modules)
         (call-interactively #'verilog-ext-find-module-instance-bwd-2))
        (t
         (call-interactively #'verilog-ext-find-function-task-bwd))))



;;; Setup
(add-hook 'verilog-mode-hook #'verilog-ext-navigation-hook)
(add-hook 'ag-search-finished-hook #'verilog-ext-navigation-ag-rg-hook)
(add-hook 'ripgrep-search-finished-hook #'verilog-ext-navigation-ag-rg-hook)


(provide 'verilog-navigation)

;;; verilog-navigation.el ends here
