require_relative "static_array"
require 'byebug'

class DynamicArray < StaticArray
  attr_reader :length

  def initialize
    @arr = StaticArray.new(8)
    @length = 0
    @capacity = 8
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if index >= @length
    @arr[index]
  end

  # O(1)
  def []=(index, value)
    # debugger
    raise "index out of bounds" if index >= @length
    @arr[index] = value
  end

  # O(1)
  def pop
    # debugger
    raise "index out of bounds" if @length == 0
    ans = @arr[@length - 1]
    @arr[@length - 1] = nil
    @length -= 1
    ans
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    # debugger
    if @length+1 > @arr.length
      old = @arr 
      @arr = StaticArray.new(@length * 2)
      @capacity = @capacity * 2
      old.store.each_with_index do |el, idx|
        @arr[idx] = el
      end
      @arr[@length] = val
      @length = @length * 2
    else
      @arr[@length] = val
      @length = @length + 1
    end
  end

  # O(n): has to shift over all the elements.
  def shift
    raise "index out of bounds" if @length == 0
    old = @arr 
    ans = @arr[0]
    @arr = StaticArray.new(@length - 1)
    old.store.each_with_index do |el, idx|
      @arr[idx-1] = el if idx > 0
    end
    @length = @length - 1
    ans
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    old = @arr 
    @arr = StaticArray.new(@length + 1)
    @arr[0] = val
    old.store.each_with_index do |el, idx|
      @arr[idx+1] = el
    end
    @length = @length + 1
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
  end
end
