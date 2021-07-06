# Exceptions

* An exception is an exceptional state in the code.
This is not necessarily a bad thing, but if the code does not specify a way to handle the exception, the program will crash
* Errors of the `StandardError` class like `ZeroDivisionError` or `NoMethodError` are relatively safe to handle and continue the program
* Other errors like `NoMemoryError` or `SystemStackError` must be addressed properly for the program to operate properly
* Handling an exception refers to using a `begin / rescue` block. An example is shown below.
Make sure not to rescue the `Exception` class, because this would rescue all exceptions in the `Exception` class hierarchy and potentially very dangerous.

```ruby { .line-numbers }
begin
  # code at risk of failing here
rescue StandardError => e   # storing the exception object in e
  puts e.message            # output error message
end
```

* Using the `ensure` keyword will make sure a branch will always execute regardless of an exception being raised or how it was handled.
An example is below:

```ruby { .line-numbers }
file = open(file_name, 'w')
begin
  # do something with file
rescue
  # handle exception
rescue
  # handle a different exception
ensure
  file.close
  # executes every time
end
```

* Using the `retry` keyword will take you back to the `begin` statement.

```ruby { .line-numbers }
RETRY_LIMIT = 5
begin
  attempts = attempts || 0
  # do something
rescue
  attempts += 1
  retry if attempts < RETRY_LIMIT
end
```

* A custom error can be defined and raised as seen below:

```ruby { .line-numbers }
class ValidateAgeError < StandardError; end

unless (0..105).include?(1000)
  raise ValidateAgeError, "Invalid Age"
end
```
