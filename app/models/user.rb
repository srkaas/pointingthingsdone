class User < ActiveRecord::Base
  serialize :current_points, Hash
  serialize :total_points, Hash
  serialize :points_today, Hash

  # Calculate the total number of level 0 points equivalent to the
  # scored points.
  def point_equivalents(hash)
    total = 0
    0.upto(PointsData::MAX_WEIGHT) do |i|
      total += PointsData::MINUTES_EQUIVALENT_FOR_WEIGHT[i] * hash[i].to_i
    end
    total
  end

  # Check if there's something wrong with the user object.
  def bad?
    return true unless self.current_points
    return true unless self.total_points
    return true unless self.points_today
    return true unless self.current_points[0]
    return true unless self.total_points[0]
    return true unless self.points_today[0]
  end

  # Empty the user object (called if it's bad).
  def make_empty
    self.current_points = {}
    self.total_points = {}
    self.points_today = {}
    0.upto(PointsData::MAX_WEIGHT) do |i|
      self.current_points[i] = 0
      self.total_points[i] = 0
      self.points_today[i] = 0
    end
  end
end