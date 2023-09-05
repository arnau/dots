;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sauron, the ring ruler.
;;
;; Allows defining rings (aka modals) and keeping track of which one is enabled.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
"
Sauron, the ring ruler.

# Usage

```fennel
;; Make a ruling ring to control them all.
(global RulingRing (sauron.make-ring {:id :ruling-ring
                                      :sigil :s
                                      :trigger {:mods [:alt] :key :space}}))
(local music-ring)
```
"

(local {: copytable} (require :my.prelude))
(local trail (require :my.trail))

(local module {})
(set module._about {:name "Sauron"
                    :description "A ring ruler. A ring is a modal with a predefined set of hotkeys."
                    :version "0.1.0"
                    :author "Arnau Siches"
                    :license "MIT"})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(fn disable-binding [binding]
  "
  Disables the given binding.
  "
  (binding:disable))

(fn enable-binding [binding]
  "
  Enables the given binding when not already enabled.
  "
  (when (not binding.enabled)
    (binding:enable))
  binding)


(fn make-binding [{: mods
                   : key
                   : on-press
                   : on-release
                   : on-hold}]
    "
    Thin wrapper to make the arguments a labelled table.
    "
    (hs.hotkey.new mods key on-press on-release on-hold))


(fn wrap-callback [callback ctx]
  "
  Decorates the given function with the ring context.

  This function ensures callbacks have the signature `ctx -> any` such that you can
  manipulate the ring context from an action callback.
  "
  (if (= (type callback) "function")
    (fn [] (callback ctx))
    callback))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ring
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(local ring {})


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hooks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(fn ring.on-before-enable [self]
  nil)

(fn ring.on-after-enable [self]
  nil)

(fn ring.on-before-disable [self]
  nil)

(fn ring.on-after-disable [self]
  nil)

(fn ring.on-after-dismiss [self]
  nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(fn ring.show [self]
  "
  Displays the ring on the screen.
  "
  (set self.display (hs.menubar.new))
  (self.display:setTitle self.config.sigil)

  self)

(fn ring.hide [self]
  "
  Removes the ring from the screen.
  "
  (self.display:delete)

  self)

(fn ring.bind-ring [self value]
  "
  Binds a ring to the ring.
  "
  (assert (= value.type :ring) "The given value must be of type ring.")

  (let [{: id : trigger} value.config
        {: mods : key} trigger
        ctx value.context]
    (tset self.rings id ring)

    ;; register parent
    (tset ctx :parent self)
    ;; register sub-ring context
    (tset self.context id ctx)

    (tset self.bindings [mods key] value.trigger))
  
  (set value.on-before-enable #(self:disable))
  (set value.on-after-disable #(self:enable))
  
  self)



(fn ring.bind-action [self value]
  "
  Binds an action to the ring.
  "
  (let [{: mods
         : key
         : type
         : on-press
         : on-release
         : on-hold} value
        ctx self.context]
    (assert (= type :action) "The given value must be of type action.")
    (tset self.bindings [mods key]
                        (make-binding {: mods
                                       : key
                                       :on-press (wrap-callback on-press ctx)
                                       :on-release (wrap-callback on-release ctx)
                                       :on-hold (wrap-callback on-hold ctx)})))
                                     
  self)


(fn ring.disable [self]
  "
  Disables all bindings for the ring.
  "

  (self:hide)
  (self.releaser:disable)
   
  (each [k binding (pairs self.bindings)]
    (disable-binding binding))
  self)  

  
(fn ring.dismiss [self]
  "
  Disables all rings in the chain effectively returning to the resting state.
  "

  (self:disable)
  (self.dismisser:disable)
  (self.on-after-dismiss)

  ;; Triggers a dismissal all the way up the chain of rings.
  (if self.context.parent
    (self.context.parent:dismiss)
    (self.trigger:enable))

  
  self)

(fn ring.enable [self]
  "
  Enables all bindings for the ring.
  "
  (self:show)
  (self.trigger:disable)
  (self.releaser:enable)
  (self.dismisser:enable)

  (each [k binding (pairs self.bindings)]
    (enable-binding binding))
  self)

(fn ring.activate [self]
  "
  Activates the ring.

  TODO: This should activate the trigger.
  The name is confusing sounds simlar to ring.enable.
  "
  (self.trigger:enable)
  self)

(fn module.make-ring [config]
  "
  Makes a new ring bound to the given trigger. Bindings should be added via `bind`.
  "
  (local m (copytable ring))
  (set m.type :ring)

  ;; Runtime context. Callbacks and hooks should be exposed to this.
  ;; Each context ring can contain a reference to its parent ring. See `ring.bind-ring`
  (set m.context {})
  (set m.config config)
  (set m.bindings {})
  (set m.rings {})
  (set m.tray (trail.make-trail [config.sigil]))

  (set m.releaser (hs.hotkey.new [] :q (fn [] 
                                          (m:on-before-disable)
                                          (m:disable)
                                          (m.trigger:enable)
                                          (m:on-after-disable))))

  (set m.dismisser (hs.hotkey.new [] :escape (fn []
                                                (m:dismiss))))

  (let [{: trigger } config]
    (set m.trigger (hs.hotkey.new
                      trigger.mods
                      trigger.key
                      (fn [] (m:on-before-enable)
                             (m:enable)
                             (m:on-after-enable)))))

  m)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exports
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
module