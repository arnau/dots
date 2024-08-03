;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Trail. Composes a trail of marks, where each mark has a stone and a rune.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(local {: math} (require :my.prelude))
(local style-text hs.styledtext.new)
(local text-drawing-size hs.drawing.getTextDrawingSize)
(local canvas hs.canvas.new)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(local module {})

(local palette {:pink {:hex "#ffc0cb" :alpha 1}
                :black {:hex "#000000" :alpha 0.7}})

(set module.config {})

(set module.config.rune {:color palette.pink
                         :size 64
                         :font "Menlo"})

(set module.config.stone {:color palette.black
                          :radius 10
                          :stroke-width 1})


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Internal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(fn style-rune [text {: color : size : font}]
  (style-text text {:font {:name font : size}
                    : color}))

(fn make-rune [text id frame]
  {:type :text
   : id
   : text
   : frame})

(fn make-stone [id frame config]
  {:type :rectangle
   : id
   : frame
   :fillColor config.stone.color
   :strokeColor config.rune.color
   :strokeWidth config.stone.stroke-width
   :roundedRectRadii {:xRadius config.stone.radius
                      :yRadius config.stone.radius}})

(fn make-mark [text coord config]
  "
  A mark is composed of a stone and a rune. This function returns the pair of
  objects that can be inserted into a HS canvas.
  "
  (let [stroke-width config.stone.stroke-width
        pad (// config.rune.size 4)
        stext (style-rune text config.rune)
        stext-size (text-drawing-size stext)
        width (math.round stext-size.w)
        height (math.round stext-size.h)
        rune (make-rune stext 
                        (.. :mark-rune "-" text)
                        {:x (+ coord.x pad (* stroke-width 2))
                         :y coord.y
                         :w width
                         :h height})
        stone (make-stone (.. :mark-stone "-" text)
                          {:x coord.x
                           :y coord.y
                           :w (+ width (* stroke-width 2) (* pad 2))
                           :h height}
                          config)]
    [stone rune]))

(fn set-marks [trail size marks]
  (each [idx rune (ipairs marks)]
    (let [x (* (+ size (// size 4)) (- idx 1))
          y 0
          mark (make-mark rune {: x : y} module.config)]
      (trail:appendElements mark))))

(fn module.make-trail [sigils]
  (assert (and sigils (> (length sigils) 0)) "A trail needs at least one sigil")

  (let [screen (hs.screen.mainScreen)
        frame (screen:fullFrame)
        width (// frame.w 4)
        height (// frame.h 2)
        trail (canvas {:x (- (// frame.w 2) (// width 2))
                       :y (- (// frame.h 2) (// height 2))
                       :w width
                       :h height})]
    (set-marks trail 64 sigils)
    trail))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
module