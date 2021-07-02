class Student
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other_student)
    @grade > other_student.grade
  end

  protected

  def grade
    @grade
  end
end

joe = Student.new("Joe", 88)
bob = Student.new("Bob", 70)

puts "Well done!" if joe.better_grade_than?(bob)

# Protected methods can be called inside the class on other objects of the same class