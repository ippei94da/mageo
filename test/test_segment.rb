#! /usr/bin/env ruby
# coding: utf-8

require "test/unit"
require "helper"
require 'mageo.rb'
#require "mageo/segment.rb"

class TC_Segment < Test::Unit::TestCase
  $tolerance = 1.0 * 10.0 ** (-10)

  VEC_00 = Mageo::Vector3D[1.0, 2.0, 3.0]
  VEC_01 = Mageo::Vector3D[4.0, 6.0, 8.0]

  VEC_10 = Mageo::Vector3D[0.0, 0.0, 1.0]
  VEC_11 = Mageo::Vector3D[0.0, 0.0, 3.0]

  VEC_20 = Mageo::Vector3D[1.0, 1.0, 1.0]
  VEC_21 = Mageo::Vector3D[0.0, 0.0, 0.0]
  def setup
    @s00 = Mageo::Segment.new(VEC_00, VEC_01)
    @s01 = Mageo::Segment.new(VEC_10, VEC_11)
    @s02 = Mageo::Segment.new(VEC_20, VEC_21)
  end

  def test_initialize
    vec00 = [1.0, 2.0, 3.0]
    vec01 = [4.0, 6.0, 8.0]
    assert_raise(Mageo::Segment::InitializeError){
      Mageo::Segment.new(vec00, vec01)
    }
    assert_raise(Mageo::Segment::InitializeError){
      Mageo::Segment.new(VEC_00, VEC_00)
    }
  end

  def test_endpoints
    assert_equal(VEC_00, @s00.endpoints[0])
    assert_equal(VEC_01, @s00.endpoints[1])
  end

  def test_include?
    assert_raise(Mageo::Segment::TypeError){
      @s02.include?([0.0, 0.0, 0.0], $tolerance)
    }

    #直線上
    assert_equal(false, @s02.include?(Mageo::Vector3D[-1.0,-1.0,-1.0], $tolerance))
    assert_equal(true , @s02.include?(Mageo::Vector3D[ 0.0, 0.0, 0.0], $tolerance))
    assert_equal(true , @s02.include?(Mageo::Vector3D[ 0.3, 0.3, 0.3], $tolerance))
    assert_equal(true , @s02.include?(Mageo::Vector3D[ 1.0, 1.0, 1.0], $tolerance))
    assert_equal(false, @s02.include?(Mageo::Vector3D[ 2.0, 2.0, 2.0], $tolerance))

    #横に出てる
    assert_equal(false, @s02.include?(Mageo::Vector3D[0.1, 0.1, 0.2], $tolerance))
    assert_equal(true , @s02.include?(Mageo::Vector3D[0.1, 0.1, 0.2], 1.0))
  end

  def test_to_v3d
    assert_equal(Mageo::Vector3D[ 3.0, 4.0, 5.0], @s00.to_v3d)
    assert_equal(Mageo::Vector3D[ 0.0, 0.0, 2.0], @s01.to_v3d)
    assert_equal(Mageo::Vector3D[-1.0,-1.0,-1.0], @s02.to_v3d)
  end

  def test_eql?
    assert_raise(Mageo::Segment::TypeError){ @s00.eql?([[0,0,0],[1,1,1]])}

    assert_equal(true , @s00.eql?(Mageo::Segment.new(VEC_01, VEC_00)))
    assert_equal(false, @s00.eql?(@s01))
  end

  def test_equal2
    assert_raise(Mageo::Segment::TypeError){ @s00.eql?([[0,0,0],[1,1,1]])}

    assert_equal(true , @s00 == Mageo::Segment.new(VEC_00, VEC_01))
    assert_equal(false, @s00 == Mageo::Segment.new(VEC_01, VEC_00))
    assert_equal(false, @s00 == @s01)
  end

  #undef test_include?
end

