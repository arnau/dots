;; CREDIT: https://github.com/agzam/spacehammer/blob/master/lib/functional.fnl

(local fu hs.fnutils)

(local module {})

(macro export [m f]
  "Registers a function to the given module"
  (let [ident (tostring f)]
    `(tset ,m ,ident ,f)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utils
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(fn noop []
  nil)
(export module noop)

(fn ?call [f ...]
  "Execute the given function if it is not nil."
  (when (= (type f) :function)
    (f ...)))
(export module ?call)

(fn contains? [x xs]
  "Checks whether a key is present in the given collection."
  (and xs (fu.contains xs x)))
(export module contains?)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Alerts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(fn alert [msg]
  ; (local style (hs.styledtext))
  (hs.alert.closeAll)
  (hs.alert msg))
(export module alert)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; List utils
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Does not control if the table is not a list.
(fn empty? [list]
  (and (= (type list) :table) (= (length list) 0)))
(export module empty?)

(fn join [sep list]
  (table.concat list sep))
(export module join)

(fn list? [x]
  "Checks whether the given argument is a list"
  (= (type x) :table))
(export module list?)

(fn first [list]
  (assert (list? list))
  (. list 1))
(export module first)

(fn last [list]
  (assert (list? list))
  (. list (length list)))
(export module last)


(fn slice-start-end
  [start end list]
  (let [end+ (if (< end 0)
              (+ (length list) end)
              end)]
    (var sliced [])
    (for [i start end+]
      (table.insert sliced (. list i)))
    sliced))

(fn slice-start
  [start list]
  (slice-start-end (if (< start 0)
                       (+ (length list) start)
                       start) (length list) list))

(fn slice
  [start end list]
  (if (and (= (type end) :table)
           (not list))
      (slice-start start end)
      (slice-start-end start end list)))

(fn module.split [sep str]
  "Splits a string with the given separator"
  (fu.split str sep))

(fn count [tbl]
  "Returns number of elements in a table"
  (var ct 0)
  (fu.each
   tbl
   (fn []
     (set ct (+ ct 1))))
  ct)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reduce Primitives
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(fn seq?
  [tbl]
  (~= (. tbl 1) nil))

(fn seq
  [tbl]
  (if (seq? tbl)
    (ipairs tbl)
    (pairs tbl)))

(fn reduce
  [f acc tbl]
  (var result acc)
  (each [k v (seq tbl)]
    (set result (f result v k)))
  result)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reducers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(fn for-each
  [f tbl]
  (fu.each tbl f))

(fn get-in
  [paths tbl]
  (reduce
   (fn [tbl path]
     (-?> tbl (. path)))
   tbl
   paths))

(fn map
  [f tbl]
  (reduce
    (fn [new-tbl v k]
      (table.insert new-tbl (f v k))
      new-tbl)
    []
    tbl))

(fn merge
  [...]
  (let [tbls [...]]
    (reduce
     (fn merger [merged tbl]
       (each [k v (pairs tbl)]
         (tset merged k v))
       merged)
     {}
     tbls)))

(fn filter
 [f tbl]
 (reduce
  (fn [xs v k]
   (when (f v k)
    (table.insert xs v))
   xs)
  []
  tbl))

(fn concat
 [...]
 (reduce
  (fn [cat tbl]
    (each [_ v (ipairs tbl)]
      (table.insert cat v))
    cat)
  []
  [...]))

(fn module.some
  [f tbl]
  (let [filtered (filter f tbl)]
    (<= 1 (length filtered))))

(fn conj
  [tbl e]
  "Return a new list with the element e added at the end"
  (concat tbl [e]))

(fn butlast
  [tbl]
  "Return a new list with all but the last item"
  (slice 1 -1 tbl))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(fn module.copytable [t1]
  (let [t2 {}]
    (each [k v (pairs t1)]
      (tset t2 k v))
    (setmetatable t2 (getmetatable t1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FileSystem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(fn module.mkdir [list]
  (os.execute (.. "mkdir -p " (join " " list))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Math
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set module.math math)
(fn module.math.round [number]
  (math.floor (+ number 0.5)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exports
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
module
