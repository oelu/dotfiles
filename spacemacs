(defun dotspacemacs/layers ()
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-configuration-layer-path '()
   dotspacemacs-configuration-layers
   '(
     auto-completion
     better-defaults
     emacs-lisp
     (osx :variables
           osx-use-option-as-meta nil)
     git
     markdown
     org
     python
     (shell :variables
             shell-default-height 30
             shell-default-position 'bottom)
     shell-scripts
     ;;(spell-checking :variables
     ;;                spell-checking-enable-auto-dictionary t)
     ;; syntax-checking
     ;; version-control
     )
   dotspacemacs-additional-packages '(elpy)
   dotspacemacs-excluded-packages '(org-bullets org-repo-todo)
   dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  (setq-default
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-check-for-update nil
   dotspacemacs-editing-style 'vim
   dotspacemacs-verbose-loading nil
   dotspacemacs-startup-banner nil
   dotspacemacs-startup-lists '(bookmarks recents projects)
   dotspacemacs-startup-recent-list-size 5
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light
                         solarized-light
                         solarized-dark
                         monokai
                         leuven
                         zenburn)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font '("Source Code Pro"
                               :size 15
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-distinguish-gui-tab nil
   dotspacemacs-command-key ":"
   dotspacemacs-remap-Y-to-y$ t
   dotspacemacs-default-layout-name "Default"
   dotspacemacs-display-default-layout nil
   dotspacemacs-auto-save-file-location 'cache
   dotspacemacs-max-rollback-slots 5
   dotspacemacs-use-ido nil
   dotspacemacs-helm-resize nil
   dotspacemacs-helm-no-header nil
   dotspacemacs-helm-position 'bottom
   dotspacemacs-enable-paste-micro-state nil
   dotspacemacs-which-key-delay 0.4
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-loading-progress-bar t
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup nil
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 90
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-smooth-scrolling t
   dotspacemacs-line-numbers t
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-persistent-server nil
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   dotspacemacs-default-package-repository nil
   dotspacemacs-whitespace-cleanup nil
   ))

(defun dotspacemacs/user-init ()
  )

(defun dotspacemacs/user-config ()

  ;; -- GENERAL SPACEMACS CONFIGURATION --
  ;; Disabled on 03.10.2016 due to performance reasons
  ;; (global-linum-mode t)
  ;; enable python elpy
  (elpy-enable)

  ;; -- GENERAL ORGMODE CONFIGURATION --
  ;; http://stackoverflow.com/questions/12262220/add-created-date-property-to-todos-in-org-mode
  ;; Allow automatically handing of created/expired meta data.
  (require 'org-expiry)
  ;; Configure it a bit to my liking
  (setq
   org-expiry-created-property-name "CREATED" ; Name of property when an item is created
   org-expiry-inactive-timestamps   t         ; Don't have everything in the agenda view
   )

  (defun mrb/insert-created-timestamp()
    "Insert a CREATED property using org-expiry.el for TODO entries"
    (org-expiry-insert-created)
    (org-back-to-heading)
    (org-end-of-line)
    (insert " ")
    )

  ;; Add a timestamp whenever org-insert-todo-heading is called.
  (defadvice org-insert-todo-heading (after mrb/created-timestamp-advice activate)
    "Insert a CREATED property using org-expiry.el for TODO entries"
    (mrb/insert-created-timestamp)
    )
  (ad-activate 'org-insert-todo-heading)

  ;; Inspired by: http://doc.norang.ca/org-mode.html
  ;; Custom Key Bindings
  (global-set-key (kbd "<f12>") 'org-agenda)
  ;; Custom TODO States
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                (sequence "WAITING(w)" "HOLD(h)" "|" "CANCELLED(c)" "PHONE" "MEETING"))))

  ;; Automatically add tags when state changes occur
  (setq org-todo-state-tags-triggers
        (quote (("CANCELLED" ("CANCELLED" . t))
                ("WAITING" ("WAITING" . t))
                ("HOLD" ("WAITING") ("HOLD" . t))
                (done ("WAITING") ("HOLD"))
                ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
                ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))


  ;; Agenda Setup
  ;; See, http://orgmode.org/manual/Storing-searches.html#Storing-searches for all options.
  (setq org-agenda-custom-commands
        '(
          ("n" todo "NEXT")
          ("w" todo "WAITING")
          )
        )


  ;; -- OS SPECIFIC CONFIGURATION --
  ;; NOTE: This configuration allows to use the right CMD key for copy and paste and the left
  ;; CMD key to input special characters.
  ;; SOURCE: https://github.com/syl20bnr/spacemacs/tree/master/layers/osx
  (setq org-agenda-files (list "~/Dropbox/orgmode/GTD.org"))
  (setq-default mac-right-option-modifier nil)

  ;; Store orgmode capture TODO's in the GTD file, section Inbox
  ;; Source: https://www.suenkler.info/docs/emacs-orgmode/
  (setq org-capture-templates
        '(("t" "TODO" entry (file+headline "~/Dropbox/orgmode/GTD.org" "Inbox")
           "* TODO %? \n:PROPERTIES:\n:CREATED: %U\n:END:")
          ;; Create Todo under GTD.org -> Work -> Tasks
          ;; file+olp specifies to full path to fill the Template
          ("w" "Work TODO" entry (file+olp "~/Dropbox/orgmode/GTD.org" "Work" "Tasks")
           "* TODO %? \n:PROPERTIES:\n:CREATED: %U\n:END:")
        ;; Create Todo under GTD.org -> Private -> Tasks
        ;; file+olp specifies to full path to fill the Template
        ("p" "Private TODO" entry (file+olp "~/Dropbox/orgmode/GTD.org" "Private" "Tasks")
         "* TODO %? \n:PROPERTIES:\n:CREATED: %U\n:END:")
        ))

  ;; Orgmode files path is different on windows
  (case system-type
    ('windows-nt
    (setq org-agenda-files (list "c:/share/Dropbox/orgmode/GTD.org"))
    (setq org-capture-templates
          '(("t" "TODO" entry (file+headline "c:/share/Dropbox/orgmode/GTD.org" "Inbox")
             "* TODO %? \n:PROPERTIES:\n:CREATED: %U\n:END:")
            ;; Create Todo under GTD.org -> Work -> Tasks
            ;; file+olp specifies to full path to fill the Template
            ("w" "Work TODO" entry (file+olp "c:/share/Dropbox/orgmode/GTD.org" "Work" "Tasks")
             "* TODO %? \n:PROPERTIES:\n:CREATED: %U\n:END:")
            ;; Create Todo under GTD.org -> Private -> Tasks
            ;; file+olp specifies to full path to fill the Template
            ("p" "Private TODO" entry (file+olp "c:/share/Dropbox/orgmode/GTD.org" "Private" "Tasks")
             "* TODO %? \n:PROPERTIES:\n:CREATED: %U\n:END:")
            ))
      )
    )
  ;;(case system-type
  ;;  ('darwin (setq org-agenda-files (list "~/Dropbox/orgmode/GTD.org"))))

  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#bcbcbc" "#d70008" "#5faf00" "#875f00" "#268bd2" "#800080" "#008080" "#5f5f87"])
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(fci-rule-color "#073642" t)
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(hl-bg-colors
   (quote
    ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(hl-sexp-background-color "#efebe9")
 '(magit-diff-use-overlays nil)
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(package-selected-packages
   (quote
    (eyebrowse fish-mode zenburn-theme monokai-theme elpy find-file-in-project ivy reveal-in-osx-finder pbcopy osx-trash launchctl xterm-color shell-pop multi-term eshell-prompt-extras esh-help solarized-theme toc-org smeargle pyvenv pytest pyenv-mode py-yapf pip-requirements orgit org-repo-todo org-present org-pomodoro alert log4e gntp org-plus-contrib org-bullets mmm-mode markdown-toc markdown-mode magit-gitflow hy-mode htmlize helm-pydoc helm-gitignore request helm-flyspell helm-company helm-c-yasnippet gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger gh-md evil-magit magit magit-popup git-commit with-editor cython-mode company-statistics company-quickhelp pos-tip company-anaconda company auto-yasnippet yasnippet auto-dictionary anaconda-mode pythonic f ac-ispell auto-complete ws-butler window-numbering volatile-highlights vi-tilde-fringe spaceline s powerline smooth-scrolling restart-emacs rainbow-delimiters popwin persp-mode pcre2el paradox hydra spinner page-break-lines open-junk-file neotree move-text macrostep lorem-ipsum linum-relative leuven-theme info+ indent-guide ido-vertical-mode hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation help-fns+ helm-themes helm-swoop helm-projectile helm-mode-manager helm-make projectile pkg-info epl helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery expand-region exec-path-from-shell evil-visualstar evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-args evil-anzu anzu eval-sexp-fu highlight elisp-slime-nav define-word clean-aindent-mode buffer-move bracketed-paste auto-highlight-symbol auto-compile packed dash aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core popup async quelpa package-build use-package which-key bind-key bind-map evil spacemacs-theme)))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#c85d17")
     (60 . "#be730b")
     (80 . "#b58900")
     (100 . "#a58e00")
     (120 . "#9d9100")
     (140 . "#959300")
     (160 . "#8d9600")
     (180 . "#859900")
     (200 . "#669b32")
     (220 . "#579d4c")
     (240 . "#489e65")
     (260 . "#399f7e")
     (280 . "#2aa198")
     (300 . "#2898af")
     (320 . "#2793ba")
     (340 . "#268fc6")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83")))
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))
(custom-set-faces
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil)))))

