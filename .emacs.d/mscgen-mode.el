;;; swig-mode.el

;; Copyright 2014 Theldoria
;;
;; Author: theldoria@hotmail.com
;; Time-stamp: <2014-03-10 10:15:19 roland>
;; Version: 0.1

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 2 of the License, or
;; (at your option) any later version.

;; It is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
;; License for more details.

;; You should have received a copy of the GNU General Public License
;; along with it.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'mscgen-mode)

;;; Code:

(eval-when-compile
  (require 'cl))

;;; Options

;;;###autoload
(define-derived-mode mscgen-mode
  dot-mode "mscgen"
  "Major mode for mscgen."
  (interactive))

(add-to-list 'auto-mode-alist '("\\.\\(i\\|msc\\)$" . mscgen-mode))

(provide 'mscgen-mode)

;;; mscgen-mode.el ends here
