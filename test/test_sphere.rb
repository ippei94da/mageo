#! /usr/bin/env ruby
# coding: utf-8

require "helper"
require "test/unit"
require "mageo/sphere.rb"
require "mageo/vector3d.rb"

class TC_Sphere < Test::Unit::TestCase
  def setup
    @s00 = Sphere.new([0.0, 1.0, 2.0], 3.0)
  end

  def test_initialize
    assert_equal(Vector3D[0.0, 1.0, 2.0], @s00.position)
    assert_equal(3.0, @s00.radius)
  end

end

