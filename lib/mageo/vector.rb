#! /usr/bin/ruby

#require "mageo.rb"
#require "matrix"

class Vector
  #include Math
  class ZeroOperation < Exception; end
  class SizeError < Exception; end

  # Get a unit vector.
  def unit_vector
    len = self.r
    raise Vector::ZeroOperation if (len == 0)
    self * (1/len)
    # Vector3D.new(@x*(1.0/len), @y*(1.0/len), @z*(1.0/len))
  end

  def floor
    self.class[* self.map {|val| val.floor}.to_a]
  end
end

