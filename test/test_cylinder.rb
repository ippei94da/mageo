#! /usr/bin/env ruby
# coding: utf-8

require "helper"
#require "test/unit"
#require 'mageo.rb'
#require "mageo/cylinder.rb"
#require "mageo/vector3d.rb"

class TC_Cylinder < Test::Unit::TestCase
  def setup
    #@c00 = Mageo::Cylinder.new([[0.0, 1.0, 2.0], [1.0, 2.0, 3.0]], 3.0)
    @c00 = Mageo::Cylinder.new([0.0, 1.0, 2.0], [1.0, 2.0, 3.0], 3.0)
  end

  def test_initialize
    assert_equal(Mageo::Vector3D[0.0, 1.0, 2.0], @c00.positions[0])
    assert_equal(Mageo::Vector3D[1.0, 2.0, 3.0], @c00.positions[1])
    assert_equal(3.0, @c00.radius)
  end
end

