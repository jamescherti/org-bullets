#+TITLE: org-bullets mode
#+STARTUP: showeverything

[[screenshot.png]]

* About

Show org-mode bullets as UTF-8 characters.

*NOTE:* This is a legacy package maintained with a focus on
preservation.  It has an unofficial successor package [[https://github.com/integral-dw/org-superstar-mode][org-superstar]]).
This means that new features will no longer be added, and backwards
compatibility will be preserved.

It's unofficial successor package is available on MELPA.

* Installation

Copy the file somewhere in your `load-path`, then add something like
this to your init file.

```lisp
(require 'org-bullets)
(add-hook 'org-mode-hook 'org-bullets-mode)
```

* FAQ / Troubleshooting
** "This mode causes significant slowdown!"

I have looked into the matter [in the past](https://github.com/integral-dw/org-superstar-mode/issues/3),

and from what I understand the usual cause of this is relates to a
deeper rooted issue involving fonts and font-lock reliant packages.  I
recommend adding the following to your =.emacs=:
#+BEGIN_SRC emacs-lisp
(setq inhibit-compacting-font-caches t)
#+END_SRC or any
more fancy variation thereof.  This variable also holds further
information regarding what I believe is the cause of the problem.  If
this should not fix the problem, please consider opening an issue or
sending me a mail!
