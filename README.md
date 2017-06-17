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

  def initialize(string, hash, array)
    @gotten_string = string
    set_attr :set_hash, hash
    set_attr :accessible_array, array
    @exclusive_object = self
  end

end

something = Something.new 'string', {key: 'val'}, [1,2,3], 'object'
# => #<Something:0x00000002c82240 @gotten_string="string", @set_hash={:key=>"val"}, @accessible_array=[1, 2, 3], @exclusive_object=#<Something:0x00000002c82240 ...>>

something.gotten_string
# => "string"

something.set_hash
# => NoMethodError: undefined method `set_hash' for #<Something:0x00000002c82240>
#    Did you mean?  set_hash=
#    from (irb):41
#    from C:/tools/ruby23/bin/irb.cmd:19:in `<main>'

something.accessible_array
# => [1, 2, 3]

something.exclusive_object
# => NoMethodError: private method `exclusive_object' called for #<Something:0x00000002c82240>
#    from (irb):43
#    from C:/tools/ruby23/bin/irb.cmd:19:in `<main>'
```
