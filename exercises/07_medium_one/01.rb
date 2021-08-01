class Machine
  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  private

  def flip_switch(desired_state)
    @switch = desired_state
  end
end