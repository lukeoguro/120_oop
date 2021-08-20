# Object is added to the position that immediately follows the most recently added object.
# Removing an object always removes the object that has been in the queue the longest.

=begin

[nnn]
[1nn]
[12n]
[n2n]
[n23]
[423]

=end

class CircularQueue
  def initialize(size)
    @queue = [nil] * size
    @next_position = 0
    @oldest_position = 0
  end

  def enqueue(value)
    dequeue if @queue.none?(&:nil?)
    @queue[@next_position] = value

    @next_position += 1
    @next_position %= @queue.size
  end

  def dequeue
    return nil if @queue.all?(&:nil?)
    value = @queue[@oldest_position]
    @queue[@oldest_position] = nil

    @oldest_position += 1
    @oldest_position %= @queue.size

    value
  end
end


queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil