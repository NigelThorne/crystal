module Boot
  class Object
    module ClassMethods
    
      # return the index of the variable. Now "normal" code can't really do anything with that, but 
      # set/get instance variable use it. 
      # This is just a placeholder, as we code this in ruby, but the instance methods need the definition before.
      def index_of context , name = Vm::Integer
        index_function = Vm::Function.new(:index_of , [Vm::Integer] , Vm::Integer )
        return index_function
      end


      # in ruby, how this goes is   
      #  def _get_instance_variable var
      #     i = self.index_of(var)
      #     return at_index(i)
      #  end  
      # The at_index is just "below" the api, somehting we need but don't want to expose, so we can't code the above in ruby
      def _get_instance_variable context , name = Vm::Integer
        get_function = Vm::Function.new(:_get_instance_variable , [Vm::Integer , Vm::Integer ] , Vm::Integer )
        me = get_function.args[0]
        var_name = get_function.args[1]
        return_to = get_function.return_type
        index_function = context.object_space.get_or_create_class(:Object).get_or_create_function(:index_of)
        b = get_function.body
        b.push( [me] )
        b.call( index_function )
        b.pop([me])
        return_to.at_index( get_function.body , me , return_to )
        get_function.set_return return_to
        return get_function
      end

      def _set_instance_variable(name , value)
        raise name
      end
      
      def _get_singleton_method(name )
        raise name
      end
      def _add_singleton_method(method)
        raise "4"
      end
      def initialize()
        raise "4"
      end
    end
    extend ClassMethods
  end
end
