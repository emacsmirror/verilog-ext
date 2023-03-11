;;; verilog-ext-tests-hierarchy.el --- Verilog-Ext ERT Hierarchy  -*- lexical-binding: t -*-

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
;; ERT Tests for hierarchy
;;
;;; Code:


(defun verilog-ext-test-hierarchy ()
  (let* ((test-file (verilog-ext-path-join verilog-ext-tests-common-dir "instances.sv"))
         (verilog-library-directories `(,verilog-ext-tests-jump-parent-dir
                                        ,verilog-ext-tests-common-dir))
         (verilog-library-files `(,test-file))
         (debug nil))
    ;; Mock `verilog-ext-find-project-files' to parse only project files as those in
    ;; `verilog-ext-tests-jump-parent-dir' and the instances.sv one
    (cl-letf (((symbol-function 'verilog-ext-find-project-files)
               (lambda (&optional follow-symlinks)
                 (append (verilog-ext-find-dir-files verilog-ext-tests-jump-parent-dir follow-symlinks)
                         `(,test-file))))
              ((symbol-function 'verilog-ext-hierarchy-display-twidget)
               (lambda (hierarchy)
                 hierarchy))
              ((symbol-function 'message)
               (lambda (FORMAT-STRING &rest ARGS)
                 nil)))
      ;; Vhier cannot use temp-buffer since executes a command that requires a filename as an argument
      (cond (;; vhier-outshine
             (and (eq verilog-ext-hierarchy-backend 'vhier)
                  (eq verilog-ext-hierarchy-frontend 'outshine))
             (save-window-excursion
               (find-file test-file)
               (verilog-ext-hierarchy-current-buffer)
               (buffer-substring-no-properties (point-min) (point-max))))
            ;; vhier-hierarchy
            ((and (eq verilog-ext-hierarchy-backend 'vhier)
                  (eq verilog-ext-hierarchy-frontend 'hierarchy))
             (save-window-excursion
               (find-file test-file)
               (verilog-ext-hierarchy-current-buffer)))
            ;; builtin-hierarchy
            ((and (eq verilog-ext-hierarchy-backend 'builtin)
                  (eq verilog-ext-hierarchy-frontend 'hierarchy))
             (with-temp-buffer
               (when debug
                 (clone-indirect-buffer-other-window "*debug*" t))
               (insert-file-contents test-file)
               (verilog-mode)
               (verilog-ext-hierarchy-builtin-parse-workspace)
               (verilog-ext-hierarchy-current-buffer)))
            ;; builtin-outshine
            ((and (eq verilog-ext-hierarchy-backend 'builtin)
                  (eq verilog-ext-hierarchy-frontend 'outshine))
             (verilog-ext-hierarchy-builtin-parse-workspace)
             (save-window-excursion
               (find-file test-file)
               (verilog-ext-hierarchy-current-buffer)
               (buffer-substring-no-properties (point-min) (point-max))))
            ;; Fallback
            (t
             (error "Not a proper backend-frontend combination!"))))))

(ert-deftest hierarchy::vhier-outshine ()
  (let ((verilog-ext-hierarchy-backend  'vhier)
        (verilog-ext-hierarchy-frontend 'outshine))
    (should (string= (verilog-ext-test-hierarchy)
"// Hierarchy generated by `verilog-ext'

// * instances
// ** test_if_params
// ** test_if_params_array
// ** block0
// ** block1
// ** block2
// ** block3
// ** block_gen
// ** block_ws_0
// ** block_ws_1
// ** test_if
// ** test_if_params_empty


// * Buffer local variables
// Local Variables:
// eval: (verilog-mode 1)
// eval: (verilog-ext-hierarchy-outshine-nav-mode 1)
// End:
"))))

(ert-deftest hierarchy::builtin-hierarchy ()
  (let ((verilog-ext-hierarchy-backend  'builtin)
        (verilog-ext-hierarchy-frontend 'hierarchy))
    (should (string= (with-temp-buffer
                       (hierarchy-print (verilog-ext-test-hierarchy) (lambda (node) node))
                       (buffer-substring-no-properties (point-min) (point-max)))
"instances
  instances.block0:I_BLOCK0
  instances.block1:I_BLOCK1
  instances.block2:I_BLOCK2
  instances.block3:I_BLOCK3
  instances.block_gen:I_BLOCK_GEN
  instances.test_if:I_TEST_IF
  instances.test_if_params:ITEST_IF_PARAMS
  instances.test_if_params_array:ITEST_IF_PARAMS_ARRAY
  instances.test_if_params_empty:I_TEST_IF_PARAMS_EMPTY
  instances.block_ws_0:I_BLOCK_WS_0
  instances.block_ws_1:I_BLOCK_WS_1
"))))


(ert-deftest hierarchy::vhier-hierarchy ()
  (let ((verilog-ext-hierarchy-backend  'vhier)
        (verilog-ext-hierarchy-frontend 'hierarchy))
    (should (string= (with-temp-buffer
                       (hierarchy-print (verilog-ext-test-hierarchy) (lambda (node) node))
                       (buffer-substring-no-properties (point-min) (point-max)))
"instances
  instances.test_if_params:ITEST_IF_PARAMS
  instances.test_if_params_array:ITEST_IF_PARAMS_ARRAY
  instances.block0:I_BLOCK0
  instances.block1:I_BLOCK1
  instances.block2:I_BLOCK2
  instances.block3:I_BLOCK3
  instances.block_gen:I_BLOCK_GEN
  instances.block_ws_0:I_BLOCK_WS_0
  instances.block_ws_1:I_BLOCK_WS_1
  instances.test_if:I_TEST_IF
  instances.test_if_params_empty:I_TEST_IF_PARAMS_EMPTY
"))))

(ert-deftest hierarchy::builtin-outshine ()
  (let ((verilog-ext-hierarchy-backend  'builtin)
        (verilog-ext-hierarchy-frontend 'outshine))
    (should (equal (verilog-ext-test-hierarchy)
"// Hierarchy generated by `verilog-ext'

// * instances
// ** block0
// ** block1
// ** block2
// ** block3
// ** block_gen
// ** test_if
// ** test_if_params
// ** test_if_params_array
// ** test_if_params_empty
// ** block_ws_0
// ** block_ws_1


// * Buffer local variables
// Local Variables:
// eval: (verilog-mode 1)
// eval: (verilog-ext-hierarchy-outshine-nav-mode 1)
// End:
"))))



(provide 'verilog-ext-tests-hierarchy)

;;; verilog-ext-tests-hierarchy.el ends here
