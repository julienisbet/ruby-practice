# imported to handle any plural/singular conversions
require 'active_support/core_ext/string'


class Thing
  attr_accessor :name, :last_child, :being_the_object
  def initialize(name)
    @name = name
    @being_the_object = CreateAttribute.new(create_attribute)
  end
  
  def is_a
    CreateBoolean.new(create_boolean, true)
  end
  
  def is_not_a
    CreateBoolean.new(create_boolean, false)
  end
  
  def is_the
    CreateAttribute.new(create_attribute)
  end
  
  def has number
    CreateChildren.new(create_attribute, number)
  end
  
  def having number
    has number
  end
  
  def each &block
    puts "in each"
    puts self.name
    if last_child
      children = self.send(self.last_child)
      children.each {|c| c.each &block}
    else 
      instance_eval(&block)
    end
  end
  
  def being_the &block
    being_the_object
  end
  
  def and_the
    being_the_object
  end

  private
  
  def create_boolean
    return -> (name, return_value) do
      self.class.class_eval do
        define_method("#{name}?") { return_value }
      end
    end
  end  
  
  def create_attribute
      return -> (name, value) do
      self.class.class_eval do
        define_method("#{name}") { value }
      end
      @last_child = name
      self
    end
  end
end

class CreateChildren
  attr_accessor :args, :method_missing_block, :number
  def initialize method_missing_block, number
    @args = []
    @method_missing_block = method_missing_block
    @number = number
  end
  
  def method_missing name, *args
    return_array = Array.new(number, Thing.new(name.to_s.singularize))
    return_array.map{|t|t.is_a.send(name.to_s.singularize.to_s)}
    return_value = number > 1 ? return_array : return_array.first
    method_missing_block.call(name, return_value)
  end
end

class CreateAttribute
  attr_accessor :missing_list, :method_missing_block
  def initialize method_missing_block
    @missing_list = []
    @method_missing_block = method_missing_block
  end
  
  def method_missing name, *args, &block  
    puts "in method_missing create"
    puts name
    print missing_list  
    missing_list.push(name.to_s)
    if missing_list.length % 2 == 0
      method_missing_block.call(missing_list[-2], name.to_s)
    end
  end
end

class CreateBoolean
  attr_accessor :method_missing_block, :return_value
  def initialize(method_missing_block, return_value)
    @method_missing_block = method_missing_block
    @return_value = return_value
  end
  
  def method_missing(name)
    method_missing_block.call(name, return_value)
  end
end