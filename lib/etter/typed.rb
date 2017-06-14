require_relative "etter"

#
# Provides quick and easy ways to set attributes with type restrictions.
# Also, optionally enforces scoping, in case you have some attributes that you
# want to remain private or protected but need the dynamic handling allowed
# by +setter+ and +getter+
#
# Of course, in Ruby, type is only a suggestion, and not a requirement,
# so there are ways of getting around these settings.
#
# To use this, +extend+ your class with +Etter::Typed+
# (+include+ will work... but it doesn't really do you any good)
module Etter::Typed

  # This method is not very different from +attr_reader+, but is
  # provided because in the future, it may do something such as
  # taint the returned object if it does not match the specified
  # type, or maybe even attempt conversion, e.g.
  #   class Example
  #     getter :one,
  #       type: Integer
  #     def initialize(one)
  #       @one = one
  #       p @one
  #     end
  #   end
  #   ex = Example.new "1"
  #   # => "1"
  #   p ex.one
  #   # => 1
  # Also provides a +scope+ parameter which can be set to
  #   :public
  #   :protected
  #   :private
  def getter(name, type: Object, scope: :public)
    define_method(name.to_getter) do
      get_attr name
    end

    case scope
    when :public, "public"
      public name.to_getter
    when :protected, "protected"
      protected name.to_getter
    when :private, "private"
      private name.to_getter
    else
      raise NameError, <<~EOF
        #{scope.inspect} is not a valid scope
        Did you mean? public
                      protected
                      private
      EOF
    end
  end

  #
  # Like +attr_writer+ except that when the instance methods
  # it creates are called, the incoming object is checked
  # against the class provided with the +type+ parameter
  #
  # Also provides a +scope+ parameter which can be set to
  #   :public
  #   :protected
  #   :private
  #
  def setter(name, type: Object, scope: :public)
    define_method(name.to_setter) do |value|
      raise TypeError, "#{name.to_attr} must be a #{type}" unless
        value.is_a? type
      set_attr name, value
    end

    case scope
    when :public, "public"
      public name.to_setter
    when :protected, "protected"
      protected name.to_setter
    when :private, "private"
      private name.to_setter
    else
      raise NameError, <<~EOF
        #{scope.inspect} is not a valid scope
        Did you mean? public
                      protected
                      private
      EOF
    end
  end

  #
  # Like +attr_accessor+ , but encompasses the properties mentioned
  # in +setter+ and +getter+
  #
  def property(name, type: Object, scope: :public)
    getter name,
      type: type,
      scope: scope

    setter name,
      type: type,
      scope: scope
  end

  private
  def self.extended(mod)
    mod.include(InstanceMethods)
  end

  #
  # Automatically +include+ d when +Etter::Typed+ extends
  # a class
  #
  module InstanceMethods
    private

    #
    # Gets an instance variable, accepting either of the following:
    #   get_attr :name
    #   get_attr :@name
    #
    def get_attr(name) # :doc:
      instance_variable_get Etter.new(name)
    end

    #
    # Sets an instance variable, accepting either of the following:
    #   set_attr :name, "value"
    #   set_attr :@name, "value"
    #
    def set_attr(name, value) # :doc:
      instance_variable_set Etter.new(name), value
    end
  end

end
