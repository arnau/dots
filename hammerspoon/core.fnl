;;; CREDIT: Inspired by https://github.com/agzam/spacehammer and HammerSpoon.

;; Spoons should be loaded before any use in Fennel.
(global spoon (or _G.spoon {}))
(local fennel (require :fennel))

(local config_dir hs.configdir)
(local home-path (os.getenv "HOME"))

(local {: prelude
        : sauron
        : tomata-ring
        : music-ring
        : notify
        : install-cli} (require :my))
(local {: watch-config-files} (require :config_management))
(local focus-finder (require :focus_finder))
(local alert hs.alert.show)

(local config {
  ;; The default path is `/usr/local` but `~/.local` makes it more cozy.
  :cli-path (.. home-path "/" ".local")
})

;;; Checks whether the hs CLI is installed and if not it attempts to install it at
;;; the configured location.
(when (not (hs.ipc.cliStatus config.cli-path))
  (notify (.. "The hammerspoon CLI could not be found at " config.cli-path))
  (install-cli config.cli-path))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ring Ruler
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global RulingRing (sauron.make-ring {:id :ruling-ring
                                      :sigil :s
                                      :trigger {:mods [:alt] :key :space}}))

(local {:ui hs-ui} (require :hs.window.highlight))
(fn RulingRing.on-after-enable [self]
  (alert "sauron"))


(RulingRing:bind-action {:type :action
                         :mods [:ctrl]
                         :key :c
                         :on-press (fn [] (hs.openConsole))})

;; show the current week and time
(RulingRing:bind-action {:type :action
                         :mods [:ctrl]
                         :key :t
                         :on-press (fn [] (alert (os.date "%Y-W%W %H:%M")))})

;; show the current mouse position and active window
(RulingRing:bind-action {:type :action
                         :mods [:ctrl]
                         :key :d
                         :on-press (fn [] (focus-finder:show))})

(RulingRing:bind-ring music-ring)
(RulingRing:bind-ring tomata-ring)

;; Trigger on
(RulingRing:activate)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Experiments
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global my (require :my))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Calling this global stops the watcher
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global config-files-watcher (watch-config-files config_dir))