(load "~/.emacs.d/sanemacs.el")

;;; An example configuration of helm
;;; The 'helm' will automatically be installed if not already,
;;; thanks to use-package.
(use-package helm
  :bind ("M-x" . helm-M-x)
  :bind ("C-x r b" . helm-filtered-bookmarks)
  :bind ("C-x C-f" . helm-find-files)
  :init
  (require 'helm-config)
  (helm-mode 1))
