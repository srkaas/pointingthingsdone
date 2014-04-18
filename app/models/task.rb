class Task < ActiveRecord::Base
  # Make a task active. Called from "possibly_activate", which is called from
  # the main screen controller when the page loads.
  def activate
    self.activated = true
    self.save
    Message.create(contents: "New task activated: #{self.description}.")
  end

  # Activate the task with a probability depending on time elapsed since last
  # load and on the task's urgency.
  def possibly_activate(time_elapsed)
    # If urgency is unset, which it shouldn't be, set it to zero.
    self.urgency = 0 unless self.urgency
    unless self.activated
      # Probability of activation is proportional to time elapsed multiplied
      # by 10 for each two points of urgency.
      # At current settings, the probability reaches 1 in ten seconds if the 
      # urgency is 10, a hundred seconds if the urgency is 8, and so on.
      # About twelve days for urgency 0.
      self.activate if rand < time_elapsed *
        (10 ** (self.urgency/2.0)) / 1000000.0
    end
  end
end