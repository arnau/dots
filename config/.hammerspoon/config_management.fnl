;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Config management
;;
;; CREDIT: Heavily borrowed from https://github.com/agzam/spacehammer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(local {: contains?
        : last
        : split
        : some} (require :my.prelude))

(local clear-console hs.console.clearConsole)
(local reload-hs hs.reload)
(local pathwatcher hs.pathwatcher.new)
(local alert hs.alert.show)


(fn config-file?
  [filename]
  "Check whether the given filename is a config file."
  (let [ext (last (split "%p" filename))]
    (contains? ext ["lua" "fnl"])))

(fn reload-config
  [filenames]
  "Reloads Hammerspoon if the list of filenames contain any source file."
  (when (some config-file? filenames)
    (clear-console)
    (reload-hs)))


(fn watch-config-files
  [dir]
  "
  Watches config files and reloads Hammerspoon when one changes.
  Takes a directory to watch.
  Returns a function to stop the watcher.
  "
  (let [watcher (pathwatcher dir reload-config)]
    (watcher:start)
    (alert "Config loaded")
    #(watcher:stop)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exports
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
{: watch-config-files
 : reload-config}
