(local module {})

(fn module.add [stack item]
  "Adds an item at the top of the stack."
  (table.insert stack 1 item)
  stack)

(fn module.pop [stack]
  "Pops the item at the top of the stack."
  (table.remove stack 1))

(fn module.peek [stack]
  (. stack 1))


module