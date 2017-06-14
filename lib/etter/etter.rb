#
# Top level namespace for Etter. Behaves somewhat like a class, in that you can
# send +::new+ to it, but will not return anything other than a +String+ or
# +Sumbol+
#
module Etter
  ERROR = "is not allowed as an instance variable name"

  class << self
    #call-seq:
    #  new(string) => string
    #  new(symbol) => symbol
    def new(obj)
      attribute = _attrify(obj)
      if obj.is_a? Symbol
        return attribute.intern
      else
        return attribute
      end
    end

    def getter(obj)
      _validate_internal obj
      obj.intern
    end

    def setter(obj)
      _validate_internal obj
      (obj.to_s + "=").intern
    end

    private
    def _attrify(obj)
      _validate_internal(obj)
      obj = literal2snk(obj)
      if obj[0] == '@'
        return obj
      else
        return obj.prepend '@'
      end
    end

    def literal2snk(obj)
      rep = obj.to_s.gsub('-', '_')
      rep
    end

    def _validate_internal(obj)
      raise NameError, "`#{obj}' #{ERROR}" unless
        obj.is_a?(String) || obj.is_a?(Symbol)
      raise NameError, "`#{obj}' #{ERROR}" unless
        obj[0] =~ /[a-zA-Z@]/
      raise NameError, "`#{obj}' #{ERROR}" unless
        obj.to_s[1..-1].scan(/[^a-zA-Z0-9_-]/).empty?
    end

    def self.extended(mod)
      raise "cannot extend this module."
    end

  end
end

require_relative "string"
require_relative "symbol"
