(defmodule B
  (def add (x y)
    (+ x y)
  )

  (def square (z)
    (* z z)
  )

  (def cube (x)
   (* x (square x))
  )

  ; this function is just awful
  (def six ()
    (6)
  )
)
