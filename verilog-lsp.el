;;; verilog-lsp.el --- SystemVerilog LSP Setup  -*- lexical-binding: t -*-

;; Copyright (C) 2022-2023 Gonzalo Larumbe

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
;; Support for various SystemVerilog language servers
;;  - Builtin:
;;     - hdl_checker: https://github.com/suoto/hdl_checker
;;     - svlangserver: https://github.com/imc-trading/svlangserver
;;  - Additional:
;;     - verible: https://github.com/chipsalliance/verible/tree/master/verilog/tools/ls
;;     - svls: https://github.com/dalance/svls
;;     - veridian: https://github.com/vivekmalneedi/veridian
;;
;;; Code:


;;;; Common
(defcustom verilog-ext-lsp-available-servers
  '((ve-hdl-checker  . ("hdl_checker" "--lsp"))
    (ve-svlangserver . "svlangserver")
    (ve-verible-ls   . "verible-verilog-ls")
    (ve-svls         . "svls")
    (ve-veridian     . "veridian"))
  "Verilog-ext available LSP servers."
  :type '(alist :key-type (symbol)
                :value-type (string))
  :group 'verilog-ext)


(defconst verilog-ext-lsp-server-ids
  (mapcar #'car verilog-ext-lsp-available-servers))


;;;; lsp-mode
(require 'lsp-mode)
(require 'lsp-verilog)

(defvar verilog-ext-lsp-mode-default-server 've-svlangserver)


(defun verilog-ext-lsp-configure ()
  "Configure Verilog for `lsp-mode'.
Register additional clients."
  (interactive)
  (let (server-id server-bin)
    ;; Add `verilog-ts-mode' to the list of existing lsp ids
    (unless (alist-get 'verilog-ts-mode lsp-language-id-configuration)
      (push (cons 'verilog-ts-mode "verilog") lsp-language-id-configuration))
    ;; Register clients
    (dolist (server verilog-ext-lsp-available-servers)
      (setq server-id (car server))
      (setq server-bin (cdr server))
      (cond ((eq server-id 've-svlangserver)
             (lsp-register-client
              (make-lsp-client :new-connection (lsp-stdio-connection 'lsp-clients-svlangserver-command)
                               :major-modes '(verilog-mode verilog-ts-mode)
                               :library-folders-fn 'lsp-clients-svlangserver-get-workspace-additional-dirs
                               :server-id server-id)))
            (t
             (lsp-register-client
              (make-lsp-client :new-connection (lsp-stdio-connection server-bin)
                               :major-modes '(verilog-mode verilog-ts-mode)
                               :server-id server-id))))
      (message "Registered lsp-client: %s" server-id))))

(defun verilog-ext-lsp-set-server (server-id)
  "Set language server defined by SERVER-ID.
Disable the rest to avoid handling priorities.
Override any previous configuration for `verilog-mode' and `verilog-ts-mode'."
  (interactive (list (intern (completing-read "Server-id: " verilog-ext-lsp-server-ids nil t))))
  (let ((cmd (cdr (assoc server-id verilog-ext-lsp-available-servers))))
    (if (not (executable-find (if (listp cmd)
                                  (car cmd)
                                cmd)))
        (message "%s not in $PATH, skipping config..." server-id)
      ;; Else configure available server
      (dolist (mode '(verilog-mode verilog-ts-mode))
        (setq lsp-disabled-clients (assq-delete-all mode lsp-disabled-clients))
        (push (cons mode (remove server-id verilog-ext-lsp-server-ids)) lsp-disabled-clients))
      (message "[Verilog LSP]: %s" server-id))))


;;;;; Default config
(verilog-ext-lsp-configure)
(verilog-ext-lsp-set-server verilog-ext-lsp-mode-default-server)


;;;; eglot
(require 'eglot)

(defvar verilog-ext-eglot-default-server 've-svlangserver)

(defun verilog-ext-eglot-set-server (server-id)
  "Configure Verilog for `eglot'.
Override any previous configuration for `verilog-mode' and `verilog-ts-mode'."
  (interactive (list (intern (completing-read "Server-id: " verilog-ext-lsp-server-ids nil t))))
  (let ((cmd (alist-get server-id verilog-ext-lsp-available-servers)))
    (unless cmd
      (error "%s not recognized as a supported server" server-id))
    (if (not (executable-find (if (listp cmd)
                                  (car cmd)
                                cmd)))
        (message "%s not in $PATH, skipping config..." server-id)
      ;; Else configure available server
      (dolist (mode '(verilog-mode verilog-ts-mode))
        (setq eglot-server-programs (assq-delete-all mode eglot-server-programs))
        (if (listp cmd)
            (push (append (list mode) cmd) eglot-server-programs)
          (push (list mode cmd) eglot-server-programs)))
      (message "Set eglot SV server: %s" server-id))))


;;;;; Default config
(verilog-ext-eglot-set-server verilog-ext-eglot-default-server)


;;;; Provide package
(provide 'verilog-lsp)

;;; verilog-lsp.el ends here
