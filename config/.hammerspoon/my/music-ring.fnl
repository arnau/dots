;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Music Ring.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(local {: alert} (require :my.prelude))
(local sauron (require :my.sauron))
(local {: spotify} hs)


(fn pause []
    (spotify.pause))

(fn play []
  (spotify.play))

(fn toggle []
  (spotify.playpause))

(fn next-track []
  (spotify.next))
  
(fn previous-track []
  (spotify.previous))

(fn volume-up []
  (alert (spotify.getVolume))
  (spotify.volumeUp))

(fn volume-down []
  (alert (spotify.getVolume))
  (spotify.volumeDown))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(local music-ring (sauron.make-ring {:id :music
                                     :sigil :m
                                     :trigger {:key :m}}))

(music-ring:bind-action {:type :action
                         :key :space
                         :on-press #(toggle)})

(music-ring:bind-action {:type :action
                         :key :h
                         :on-press #(next-track)})
(music-ring:bind-action {:type :action
                         :key :l
                         :on-press #(previous-track)})

(music-ring:bind-action {:type :action
                         :key :j
                         :on-press #(volume-down)})

(music-ring:bind-action {:type :action
                         :key :k
                         :on-press #(volume-up)})


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
music-ring
