;;; org-bullets.el --- Show bullets in org-mode as UTF-8 characters

;; Version: 0.3.0
;; Author: sabof
;; Maintainer: D. Williams <d.williams@posteo.net>
;; Homepage: https://github.com/integral-dw/org-bullets

;; This file is NOT part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Show org-mode bullets as UTF-8 characters.

;; This is a legacy package maintained with a focus on preservation.
;; It has an unofficial successor package (org-superstar).  This means
;; that new features will no longer be added, and backwards
;; compatibility will be preserved.

;; It's unofficial successor package is available on MELPA.  You can
;; also find it on GitHub:
;; https://github.com/integral-dw/org-superstar-mode

;;; Code:

(require 'org)

(defgroup org-bullets nil
  "Display bullets as UTF-8 characters."
  :group 'org-appearance)

;; A nice collection of unicode bullets:
;; http://nadeausoftware.com/articles/2007/11/latency_friendly_customized_bullets_using_unicode_characters
(defcustom org-bullets-bullet-list
  '(;;; Large
    "◉"
    "○"
    "✸"
    "✿"
    ;; ♥ ● ◇ ✚ ✜ ☯ ◆ ♠ ♣ ♦ ☢ ❀ ◆ ◖ ▶
    ;;; Small
    ;; ► • ★ ▸
    )
  "List of bullets used in Org headings.
It can contain any number of symbols, which will be repeated."
  :group 'org-bullets
  :type '(repeat (string :tag "Bullet character")))

(defcustom org-bullets-face-name nil
  "Face used for bullets in Org mode headings.
If set to the name of a face, that face is used.
Otherwise the face of the heading level is used."
  :group 'org-bullets
  :type 'symbol)

(defvar org-bullets-bullet-map (make-sparse-keymap))

(defun org-bullets-level-char (level)
  "Return the appropriate bullet for the given heading LEVEL."
  (let* ((step (if org-odd-levels-only 2 1))
         (index (mod (/ (1- level) step) (length org-bullets-bullet-list))))
    (string-to-char (nth index org-bullets-bullet-list))))

(defvar org-bullets--keywords
  `(("^\\*+ "
     (0 (let* ((heading-start (match-beginning 0))
               (heading-end (match-end 0))
               (level (- heading-end heading-start 1))
               (is-inline-task (and (boundp 'org-inlinetask-min-level)
                                    (>= level org-inlinetask-min-level)))
               (bullet-start (1- heading-end))
               (bullet-end (- heading-end 2))
               (bullet-char (org-bullets-level-char level)))
          (compose-region bullet-end bullet-start
                          bullet-char)
          (when is-inline-task
            (compose-region (- heading-end 3) bullet-end bullet-char))
          (when (facep org-bullets-face-name)
            (put-text-property (- heading-end (if is-inline-task 3 2))
                               bullet-start 'face
                               org-bullets-face-name))
          (put-text-property heading-start bullet-end 'face 'org-hide)
          (put-text-property heading-start heading-end 'keymap
                             org-bullets-bullet-map)
          nil)))))

;;;###autoload
(define-minor-mode org-bullets-mode
  "Use UTF8 bullets in Org mode headings."
  nil nil nil
  (if org-bullets-mode
      (progn
        (font-lock-add-keywords nil org-bullets--keywords)
        (org-bullets--fontify-buffer))
    (save-excursion
      (goto-char (point-min))
      (font-lock-remove-keywords nil org-bullets--keywords)
      (while (re-search-forward "^\\*+ " nil t)
        (decompose-region (match-beginning 0) (match-end 0)))
      (org-bullets--fontify-buffer))))

(defun org-bullets--fontify-buffer ()
  "Fontify the current buffer."
  (when font-lock-mode
    (if (and (fboundp 'font-lock-flush)
             (fboundp 'font-lock-ensure))
        (save-restriction
          (widen)
          (font-lock-flush)
          (font-lock-ensure))
      (with-no-warnings
        (font-lock-fontify-buffer)))))

(provide 'org-bullets)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; org-bullets.el ends here
