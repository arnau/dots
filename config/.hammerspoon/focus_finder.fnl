;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Focus finder
;;;
;;; Spoon highlighting the mouse position as well as the current active window.
;;;
;;; CREDIT: https://github.com/Hammerspoon/Spoons/blob/master/Source/MouseCircle.spoon/init.lua
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(local {:ui hs-ui} (require :hs.window.highlight))

(local pink {:red 1
             :blue 0.4
             :green 0
             :alpha 1})

(local bag {})
(set bag.config {:colour pink
                 :radius 80
                 :stroke-width 4})
(set bag.__index bag)

(fn make-square [x y size]
  "Makes a rect geometry with equal sides."
  (hs.geometry.rect x y size size))

(fn circle-point [point
                  {: radius
                   : colour 
                   : stroke-width}]
  "Define a circle around the given point"
  (let [x (- point.x radius)
        y (- point.y radius)
        size (* radius 2)
        geometry (make-square x y size)
        circle (hs.drawing.circle geometry)]
    (circle:setStrokeColor colour)
    (circle:setFill false)
    (circle:setStrokeWidth stroke-width)
    (circle:bringToFront true)
    circle))

(fn clear-highlight [m]
  "Clears all artefacts responsible for highlighting.
   Notice that m.circle must be set to nil to ensure a new run runs properly."
  (m.circle:delete)
  (set m.circle nil)
  (hs.window.highlight.stop))

(fn bag.show [self]
  "Highlights where the mouse is and which window is active."
  (when (. self :circle)
    (self.circle:delete)
    (when (. self :timer)
      (self.timer:stop)))
    (let [point (hs.mouse.absolutePosition)
          radius 80
          circle (circle-point point self.config)]
      (set self.circle circle))

  (self.circle:show)

  (set hs-ui.overlay true)
  (set hs-ui.flashDuration 0.6)
  (hs.window.highlight.start)
  (set self.timer (hs.timer.doAfter 0.6 #(clear-highlight self)))

  self)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exports
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bag