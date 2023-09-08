;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(local module {})

(local Actions {
  :strokeAndFill ;; default
  :clip ;; append the shape to the current clipping region for the canvas. Ignored for canvas, image, and text types.
  :build ;; do not render the element -- its shape is preserved and the next element in the canvas array is appended to it. This can be used to create complex shapes or clipping regions.
  :fill
  :skip ;; ignore this element or its effects. Can be used to temporarily "remove" an object from the canvas.
  :stroke ;; outline the canvas element, if it is a shape, or display it normally if it is a canvas, image or text. Ignored for resetClip.
})

;; Primitives
(fn module.text [msg frame]
  {:type :text
   :text msg
   :textAlignment :center
   : frame})

(fn module.circle [radius fill]
  {:type :circle
   :action :fill
   : radius
   :fillColor fill})

(fn module.rect [id frame fill radii]
  {:type :rectangle
   : id
   : frame
   :fillColor fill
   :roundedRectRadii radii})


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Scene Operations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(fn module.add [scene element]
  (scene:insertElement element))

(fn module.replace [scene element idx]
  (scene:insertElement element idx))



(fn module.scene [frame]
  (hs.canvas.new frame))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
module
