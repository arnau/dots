;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tomata ring. The tomato automata.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(local {: alert
        : noop} (require :my.prelude))
(local sauron (require :my.sauron))


;; Helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(fn format-stamp [total]
  (let [minutes (// total 60)
        seconds (% total 60)]
    (string.format "%02d:%02d" minutes seconds)))


;; Timer
;;
;; states: :ticking :paused :resting
;; transitions:
;;    :resting -> :ticking
;;    :ticking -> :paused
;;    :paused  -> :ticking
;;    :paused  -> :resting
;;    :ticking -> :resting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(local timer {:status :resting
              :seconds 0
              :setup {:work 25 :rest 5}})

(fn ticking? [timer]
  (= timer.state :ticking))

(fn timer.on-tick [timer]
  nil)

(fn timer.on-last-tick [timer]
  (alert "time's up!"))

(fn timer.on-pause [timer]
  (alert "tomata paused"))

(fn timer.on-resume [timer]
  (alert "tomata resumed"))

(fn timer.on-start [timer]
  (alert "tomata started"))

(fn timer.on-stop [timer]
  (alert "tomata reset"))


(fn tick [timer]
  (if (> timer.seconds 0)
    (do
      (timer:on-tick)
      (set timer.seconds (- timer.seconds 1)))
    (do
      (timer:on-last-tick)
      (set timer.state :resting))))

(fn make-engine [predicate-fn action-fn]
  "
  Similar to hs.timer.doWhile but without starting the clock.
  "
  (local check-interval 1)
  (var engine nil)

  (set engine (hs.timer.new check-interval (fn [] 
    (if (predicate-fn)
      (action-fn engine)
      (engine:stop)))))

  engine)

(set timer.engine (make-engine #(ticking? timer) #(tick timer)))


(fn pause! [timer]
  "
  Stops the clock but it can be resumed.
  "
  (timer:on-pause)
  (set timer.state :paused)
  (timer.engine:stop))

(fn resume! [timer]
  (timer:on-resume)
  (set timer.state :ticking)
  (timer.engine:start))

(fn start! [timer duration]
  (set timer.seconds (* duration 60))
  (set timer.state :ticking)
  (timer.engine:start)
  (timer:on-start))


(fn timer.start [self]
  "
  Starts the clock.
  "
  (case self.state
    :paused (resume! self)
    :ticking (print "tomata already ticking")
    _ (start! self self.setup.work))
  self)

(fn timer.pause [self]
  "Pauses the clock"
  (case self.state
    :resting (print "tomata already completed")
    :paused (resume! self)
    :ticking (pause! self))
  self)

(fn timer.stop [self]
  "Terminates the clock"
  (self.engine:stop)
  (set self.seconds 0)
  (set self.state :resting)
  (self:on-stop)
  self)

(fn timer.display [self]
  "Displays the time left"
  (case self.state
    :resting (alert "tomata not running")
    :paused (alert (.. (format-stamp self.seconds) " (paused)"))
    :ticking (alert (format-stamp self.seconds)))
  self)


;; Ring
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(local tomata-ring (sauron.make-ring {:id :tomata
                                      :sigil :t
                                      :trigger {:key :t}}))

(set tomata-ring.context.timer timer)

(fn tomata-ring.set-duration [self {: work : rest}]
  "
  Sets the default duration of work and rest.

  The given table is expected to mirror the shape of `tomata.config.duration`. Values are in minutes.

  ```
  {:work 15
   :rest 2}
  ```
  "
  (when work
    (set self.timer.setup.work work))
  (when rest
    (set self.timer.setup.rest rest)))


;; Bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tomata-ring:bind-action {:type :action
                          :key :s
                          :on-press #(timer:start)})

(tomata-ring:bind-action {:type :action
                          :key :p
                          :on-press #(timer:pause)})

(tomata-ring:bind-action {:type :action
                          :key :t
                          :on-press #(timer:stop)})

(tomata-ring:bind-action {:type :action
                          :key :d
                          :on-press #(timer:display)})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
tomata-ring
