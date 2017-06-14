# Etter
Extension to any `Class`, providing simple, easy methods for accessing dynamic
attributes.


## Features
+ Introduces type restriction on attributes during assignment,
preventing unexpected type-weirdness from cropping up when it comes time for
Ruby to make its writes.
+ Enables scoped getters/setters to prevent unwanted/accidental access

## Use

```ruby
require "etter/typed"

class Something
  extend Etter::Typed
  getter :gotten_string,
    type: String

  setter :set_hash,
    type: Hash

  property :accessible_array,
    type: Array

  # `type' defaults to Object
  getter :exclusive_object,
    scope: :private

  def initialize(string, hash, array, object)
    @gotten_string = string
    self.set_hash = hash
    self.accessible_array = array
    @exclusive_object = object

    puts set_hash
  end
end
```
