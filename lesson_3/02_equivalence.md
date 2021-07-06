# Equivalence

## The `==` method

* The `==` method compares the values of the objects
* The default implementation of `==` in `BasicObject` compares whether the two objects are the same.
As a result, most `==` methods are custom-defined

## The `equal?` method

* The `equal?` method looks at whether the two objects are the same
* The equivalent of comparing two object ids

## The `===` method

* Not typically called explicitly, and often used in `case` statements
* Asks if an object belongs in a group
* e.g., `(1..50) === num`

## The `eql?` method

* Determines if two objects contain the same objects and if they're in the same class
* Most often used implicitly with `Hash` objects
* e.g., `{a: 1, b: 2}.eql?({b: 2, a: 1}) # true`
