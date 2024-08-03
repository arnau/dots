(local prelude (require (.. ... :.prelude)))
(local stack (require (.. ... :.stack)))
(local trail (require (.. ... :.trail)))
(local sauron (require (.. ... :.sauron)))

(local music-ring (require (.. ... :.music-ring)))
(local tomata-ring (require (.. ... :.tomata-ring)))

(local module {: prelude
               : trail
               : stack
               : sauron
               : tomata-ring
               : music-ring})

(local {: mkdir} prelude)

(fn module.install-cli [base-path]
  "
  Attempts to install the hs command-line interface ensuring the expected directory
  structure is in place.
  "
  (let [bin-path (.. base-path "/bin")
        man-path (.. base-path "/share/man")]
    (mkdir [bin-path man-path])
    (print base-path bin-path man-path)
    (hs.ipc.cliInstall base-path)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hotkey binding
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set module.hotkey {})

(fn module.hotkey.bind [{: mods : key } action]
  (hs.hotkey.bind mods key action))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Notification module
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(lambda module.notify [msg ?callback]
  "A simpler version of `hs.notify.show`"
  (let [make-notification (if (not= (type msg) :string)
    (error "A notification message must be a string")
    (hs.notify.new
      ?callback
      {:title "My Hammerspoon"
       :informativeText msg
       :autoWithdaw true}))]
    (: (make-notification msg ?callback) :send)))

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exports
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
module