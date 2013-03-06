#! /usr/bin/ruby

<<<<<<< HEAD
#require "mageo.rb"
=======
require "mageo.rb"
>>>>>>> 234bd769f956578c1d010c9f440f20bd470e8b97
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

