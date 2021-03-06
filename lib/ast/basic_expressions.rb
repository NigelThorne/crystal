# collection of the simple ones, int and strings and such

module Ast

  class IntegerExpression < Expression
    attr_reader :value
    def initialize val
      @value = val
    end
    def inspect
      self.class.name + ".new(" + value.to_s+ ")"
    end
    def to_s
      value.to_s
    end
    def compile context , into
      Vm::IntegerConstant.new value
    end
    def attributes
      [:value]
    end
  end

  class NameExpression < Expression
    attr_reader  :name
    def initialize name
      @name = name.to_sym
    end
    # compiling a variable resolves it. 
    # if it wasn't defined, nli is returned 
    def compile context , into
      context.locals[name]
    end
    def inspect
      "#{self.class.name}.new(#{name})"
    end
    def to_s
      name.to_s
    end
    def attributes
      [:name]
    end
  end

  class ModuleName < NameExpression
  end

  class StringExpression < Expression
    attr_reader  :string
    def initialize str
      @string = str
    end
    def inspect
      self.class.name + '.new("' + string + '")'
    end
    def to_s
      '"' + string.to_s + '"'
    end
    def compile context , into
      value = Vm::StringConstant.new(string)
      context.object_space.add_object value 
      value
    end
    def attributes
      [:string]
    end
  end

end