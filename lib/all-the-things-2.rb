require 'active_support/core_ext/string'
require 'sourcify'
require 'pry'

class Thing
  attr_accessor :name, :has_number, :current_method, :attributes_list, :current_child
  def initialize(name)
    @name = name
    @current_method = nil
    @has_number = nil
    @attributes_list = []
    @current_child = nil
  end
  
  def is_a
    @current_method = "is_a"
    self
  end
  
  def is_not_a
    @current_method = "is_not_a"
    self
  end
  
  def is_the
    @current_method = "is_the"
    self
  end
  
  def has number, &block
    @current_method = "has"
    @has_number = number
    self
  end
  
  def having number
    puts "in having"
    puts self.name
    has number
  end
  
  def being_the &block
    @current_method = "being_the"
    self
  end
  
  def and_the
    @current_method = "and_the"
    self
  end

  def each &block
    @current_method = "each"
    instance_eval(&block)
  end

  def method_missing name, *args, &block  
    puts "in method_missing #{name}"
    puts "current_method #{current_method}"
    case current_method
    when "is_a"
      create_method("#{name}?", true)
      @current_method = nil
    when "is_not_a"
      create_method("#{name}?", false)
      @current_method = nil
    when "is_the"
      @attributes_list.push(name.to_s)
      if attributes_list.length % 2 == 0
        create_method(attributes_list[-2], name.to_s)
        @current_method = nil
      else
        self
      end
    when "has"
      return_array = Array.new(has_number, Thing.new(name.to_s.singularize))
      return_array.map{|t|t.is_a.send(name.to_s.singularize.to_s)}
      return_value = has_number > 1 ? return_array : return_array.first
      create_method(name, return_value)
      @current_child = name
      @current_method = nil
      self
    when "each"
      puts "in each method_missing #{name}"
    else
      super
    end
  end

  private
  
  def create_method name, return_value
    self.class.class_eval do
      define_method(name) { return_value }
    end
  end  
end