require_relative "static_array"
require 'byebug'

class RingBuffer
  attr_reader :length

  def initialize
    @capacity = 8
    @start_idx = 0
    @length = 0
    @store = StaticArray.new(@capacity)
  end
# @length = capacity
# @count = length
  # O(1)
  def [](index)
    # debugger
    raise "index out of bounds" if index >= @length
    look_for = @start_idx + index
    look_for = look_for % @capacity
    @store[look_for]
  end

  # O(1)
  def []=(index, val)
    raise "index out of bounds" if index >= @capacity
    @store[index] = val
  end

  # O(1)
  def pop
    # debugger
    raise "index out of bounds" if @length == 0
    pop_index = @start_idx + @length - 1
    pop_index = pop_index % @capacity if pop_index >= @capacity 
    ans = @store[pop_index]
    @store[pop_index] = nil
    @length -= 1
    ans
  end

  # O(1) ammortized
  def push(val)
    # debugger
    put_here = (@start_idx + @length) % @capacity
    if @length+1 > @capacity
      resize_unshift!
      put_here = (@start_idx + @length) % @capacity
      @store[put_here] = val
      @length += 1
    else
      @store[put_here] = val
      @length = @length + 1
    end
    # debugger
  end

  # O(1)
  def shift
    raise "index out of bounds" if @length == 0
    ans = @store[@start_idx]
    # @store[@start_idx] = nil
    @length -= 1
    @start_idx += 1
    if @start_idx >= @capacity
      @start_idx = 0
    end 
    ans
  end

  # O(1) ammortized
  def unshift(val)
    # debugger
    resize_unshift! if @length == @capacity
    if @start_idx == 0
      @store[@capacity - 1] = val
      @start_idx = @capacity - 1
      @length += 1
    else 
      @store[@start_idx - 1] = val
      @start_idx -= 1
      @length += 1
    end

    #count increase
    #start_idx decrease
    #add at start_idx - 1
    #add at end if start_idx-1 < 0
    #start_idx = end
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def resize_unshift!
    # debugger
    # debugger
    old = @store
    old_length = @length 
    new_capacity = @capacity * 2
    # new_capacity = 1 if @capacity == 0
    @store = StaticArray.new(new_capacity)
    @length = 0
    i = 0

    while @length != old_length
      @store[i] = old[(i+start_idx)%old_length]
      @length += 1
      i += 1
      i = 0 if i == @capacity
    end
    @capacity = new_capacity
    @start_idx = 0
    # debugger

    # @capacity *=2
    # temp = StaticArray.new(@capacity)
    # @length.times do |idx|
    #   temp[idx] = @store[idx]
    # end
    # @start_idx = 0
    # @store =  temp
  end

  def resize!
    old = @store
    old_length = @length 
    new_capacity = @capacity * 2
    # new_capacity = 1 if @capacity == 0
    @store = StaticArray.new(new_capacity)
    i = 0
    while i < old_length
      @store[i] = old[i]
      # @length += 1
      i += 1
    end
    @capacity = new_capacity
  end
end
