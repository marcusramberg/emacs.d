;;; init.el --- Emacs init file
;;  Author: Marcus Ramberg
;;; Commentary:
;;; Remix based on yay emacs
;;; Code:
(defvar file-name-handler-alist-original file-name-handler-alist)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      file-name-handler-alist nil
      site-run-file nil
      debug-on-error t)

(defvar ian/gc-cons-threshold 100000000)

(add-hook 'emacs-startup-hook ;; hook run after loading init files
          (lambda ()
            (setq gc-cons-threshold ian/gc-cons-threshold
                  gc-cons-percentage 0.1
                  file-name-handler-alist file-name-handler-alist-original)))

(add-hook 'minibuffer-setup-hook (lambda ()
                                   (setq gc-cons-threshold (* ian/gc-cons-threshold 2))))
(add-hook 'minibuffer-exit-hook (lambda ()
                                  (garbage-collect)
                                  (setq gc-cons-threshold ian/gc-cons-threshold)))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq package-enable-at-startup nil)
(straight-use-package 'evil)
(straight-use-package 'org)
(use-package evil
  :diminish undo-tree-mode
  :hook (after-init . evil-mode)
  :preface
  (defun global/save-and-kill-this-buffer ()
    (interactive)
    (save-buffer)
    (kill-this-buffer))
  :config
  (with-eval-after-load 'evil-maps ; avoid conflict with company tooltip selection
    (define-key evil-insert-state-map (kbd "C-n") nil)
    (define-key evil-insert-state-map (kbd "C-p") nil))
  (evil-ex-define-cmd "q" #'kill-this-buffer)
  (evil-ex-define-cmd "wq" #'global/save-and-kill-this-buffer)
  :custom
  (evil-want-C-u-scroll t)
  (evil-want-keybinding nil)
  (evil-shift-width 2)
  (evil-vsplit-window-right t)
  (evil-split-window-below t)
  (evil-kill-on-visual-paste nil))

(org-babel-load-file (expand-file-name (concat user-emacs-directory "config.org")))

(provide 'init)
;;; init.el ends here
