(defn List
  "List type"
  [head tail]
  (set! this.head head)
  (set! this.tail tail)
  (set! this.length (+ (.-length tail) 1))
  this)

(set! List.prototype.length 0)
(set! List.prototype.tail (Object.create List.prototype))
(set! List.prototype.toString
      (fn []
        (loop [result ""
               list this]
          (if (empty? list)
            (str "(" (.substr result 1) ")")
            (recur
             (str result " " (first list))
             (rest list))))))

(defn list?
  "Returns true if list"
  [value]
  (.prototype-of? List.prototype value))

(defn count
  "Returns number of elements in list"
  [list]
  (.-length list))

(defn empty?
  "Returns true if list is empty"
  [list]
  (= (count list) 0))

(defn first
  "Return first item in a list"
  [list]
  (.-head list))

(defn second
  "Returns second item of the list"
  [list]
  (first (rest list)))

(defn third
  "Returns third item of the list"
  [list]
  (first (rest (rest list))))

(defn rest
  "Returns list of all items except first one"
  [list]
  (.-tail list))

(defn cons
  "Creates list with `head` as first item and `tail` as rest"
  [head tail]
  (new List head tail))

(defn list
  "Creates list of the given items"
  []
  (if (= (.-length arguments) 0)
    (Object.create List.prototype)
    (.reduce-right (.call Array.prototype.slice arguments)
                   (fn [tail head] (cons head tail))
                   (list))))

(defn reverse
  "Reverse order of items in the list"
  [source]
  (loop [items (array)
         source source]
    (if (empty? source)
      (.apply list list items)
      (recur (.concat (array (first source)) items)
             (rest source)))))

(defn map-list
  "Maps list by applying `f` to each item"
  [source f]
  (if (empty? source) source
      (cons (f (first source))
            (map-list (rest source) f))))

(defn concat-list
  "Returns list representing the concatenation of the elements in the
  supplied lists."
  [left right]
  (loop [result right
         prefix (reverse left)]
    (if (empty? prefix)
      result
      (recur (cons (first prefix) result)
             (rest prefix)))))

(defn list-to-vector [source]
  (loop [vector (Array)
         list source]
    (if (empty? list)
      vector
      (recur
        (.concat vector (first list))
        (rest list)))))

(export empty? count list? first second third
        rest cons list reverse
        map-list list-to-vector concat-list)
