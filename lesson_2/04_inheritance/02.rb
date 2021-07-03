class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def fetch
    'fetching!'
  end

  def swim
    'swimming!'
  end

  def speak
    'bark!'
  end
end

class Cat < Pet
  def speak
    'meow!'
  end
end