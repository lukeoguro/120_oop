class CircularQueue
  attr_accessor :values, :head, :tail

  def initialize(size)
    @values = Array.new(size)
    @head = nil
    @tail = nil
  end

  def increment(index)
    index == values.size - 1 ? 0 : index + 1
  end

  def enqueue(value)
    if head.nil? && tail.nil?
      self.head = 0
      self.tail = 0
    else
      self.head = increment(head)
      self.tail = increment(tail) if head == tail
    end
    values[head] = value
  end

  def dequeue
    return nil if tail.nil?
    value = values[tail]
    values[tail] = nil
    self.tail = increment(tail)
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