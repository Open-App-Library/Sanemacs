;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Sanemacs version 0.0.6 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Disable menu-bar, tool-bar, and scroll-bar
(menu-bar-mode -1) (tool-bar-mode -1) (scroll-bar-mode -1)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;;; Call package-initialize if needed
(unless package--initialized (package-initialize))

;;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;;; Install packages from list if not installed
(let ((installedFirstPackage nil))
  (dolist (package package-list)
    (unless (package-installed-p package)
      (unless installedFirstPackage (package-refresh-contents))
      (setq installedFirstPackage t)
      (package-install package))))

;;; Useful Defaults
(setq inhibit-startup-screen t)
(setq initial-scratch-message "")
(setq-default frame-title-format '("%b"))
(setq ring-bell-function 'ignore)
(fset 'yes-or-no-p 'y-or-n-p)
(show-paren-mode 1)

;;; Offload the custom-set-variables to a separate file
(setq custom-file "~/.emacs.d/custom.el")
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

;;; Avoid littering the user's filesystem with backups
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '((".*" . "~/.emacs.d/saves/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;;; Utility functions
(defun sanemacs--package-get-dependencies (pkg-to-check)
  (setq listofdepends nil)
  (dolist (pkg package-alist)
    (let ((desc (assoc pkg-to-check package-archive-contents)))
      (if desc
          (setq listofdepends (mapcar (lambda (elm) (car elm)) (aref (cadr desc) 4))))))
  listofdepends)

(defun sanemacs--package-is-a-dependency (pkg-to-check)
  (setq shouldreturntrue nil)
  (dolist (pkg package-alist)
    (let ((pkg-s (car pkg)))
    (when (member pkg-to-check (sanemacs--package-get-dependencies pkg-s)) (setq shouldreturntrue t))))
  shouldreturntrue)

(defun sanemacs--package-autoremove ()
  (interactive)
  (setq delete-list-human '()) ;; Human readable
  (setq delete-list-emacs '()) ;; For emacs
  (dolist (pkg package-alist) ;; Loop through all installed packages
    (setq pkg-s (car pkg))
    (setq pkg-object (car (cdr pkg)))
    (when (not (member pkg-s package-list)) ;; If not package is on user package list
      (when (not (sanemacs--package-is-a-dependency pkg-s))
        (push pkg-s delete-list-human)
        (push pkg-object delete-list-emacs))))
  (if (not (eq delete-list-human nil))
    (when (y-or-n-p (format "%s\nRemove these packages? [y/n]" delete-list-human))
      (dolist (pkg-to-del delete-list-emacs) (package-delete pkg-to-del)))
    (print "Nothing to clean.")))
