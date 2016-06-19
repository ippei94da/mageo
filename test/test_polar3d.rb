#! /usr/bin/env ruby
# coding: utf-8

#require "test/unit"
require "helper"
#require 'mageo.rb'
#require "mageo/polar3d.rb"
#require "mageo/vector3d.rb"

class TC_Polar3D < Test::Unit::TestCase
  $tolerance = 10**(-10)

  include Math

  def setup
    @p3d00 = Mageo::Polar3D.new( 0.0, 0.00*PI, 0.00*PI)
    @p3d01 = Mageo::Polar3D.new( 2.0, 0.00*PI, 0.25*PI)
    @p3d02 = Mageo::Polar3D.new( 2.0, 0.25*PI, 0.00*PI)
    @p3d03 = Mageo::Polar3D.new( 2.0, 0.25*PI, 0.25*PI)
  end

  #def test_self_polar2cartesian
  #  
  #end

  def test_to_v3d
    assert_equal( Mageo::Vector3D, @p3d00.to_v3d.class )
    assert_in_delta( 0.0, @p3d00.to_v3d[0], $tolerance )
    assert_in_delta( 0.0, @p3d00.to_v3d[1], $tolerance )
    assert_in_delta( 0.0, @p3d00.to_v3d[2], $tolerance )

    assert_equal( Mageo::Vector3D, @p3d01.to_v3d.class )
    assert_in_delta( 0.0, @p3d01.to_v3d[0], $tolerance )
    assert_in_delta( 0.0, @p3d01.to_v3d[1], $tolerance )
    assert_in_delta( 2.0, @p3d01.to_v3d[2], $tolerance )

    assert_equal( Mageo::Vector3D, @p3d02.to_v3d.class )
    assert_in_delta( Math::sqrt(2.0), @p3d02.to_v3d[0], $tolerance )
    assert_in_delta( 0.0            , @p3d02.to_v3d[1], $tolerance )
    assert_in_delta( Math::sqrt(2.0), @p3d02.to_v3d[2], $tolerance )

    assert_equal( Mageo::Vector3D, @p3d03.to_v3d.class )
    #√2 * cos(0.25PI)
    assert_in_delta( 1.0 , @p3d03.to_v3d[0], $tolerance)
    assert_in_delta( 1.0 , @p3d03.to_v3d[1], $tolerance)
    assert_in_delta( Math::sqrt(2.0), @p3d03.to_v3d[2], $tolerance )
  end

  def test_minimize_phi!
    p2pA = Mageo::Polar3D.new( 2.0, 0.5*PI, -2.5*PI )
    p2pA.minimize_phi!
    assert_in_delta( 1.5*PI, p2pA.phi, $tolerance )

    p2pB = Mageo::Polar3D.new( 2.0, 0.5*PI, -0.5*PI )
    p2pB.minimize_phi!
    assert_in_delta( 1.5*PI, p2pB.phi, $tolerance )

    p2pC = Mageo::Polar3D.new( 2.0, 0.5*PI,  1.5*PI )
    p2pC.minimize_phi!
    assert_in_delta( 1.5*PI, p2pC.phi, $tolerance )

    p2pD = Mageo::Polar3D.new( 2.0, 0.5*PI,  3.5*PI )
    p2pD.minimize_phi!
    assert_in_delta( 1.5*PI, p2pD.phi, $tolerance )

    p2pE = Mageo::Polar3D.new( 2.0, 0.5*PI,  5.5*PI )
    p2pE.minimize_phi!
    assert_in_delta( 1.5*PI, p2pE.phi, $tolerance )

    p2pF = Mageo::Polar3D.new( 2.0, 0.5*PI,  4.5*PI )
    p2pF.minimize_phi!
    assert_in_delta( 0.5*PI, p2pF.phi, $tolerance )

  end

  def test_minimize_phi
    p2pA = Mageo::Polar3D.new( 2.0, 0.5*PI, -2.5*PI ).minimize_phi
    assert_in_delta( 1.5*PI, p2pA.phi, $tolerance )

    p2pB = Mageo::Polar3D.new( 2.0, 0.5*PI, -0.5*PI ).minimize_phi
    assert_in_delta( 1.5*PI, p2pB.phi, $tolerance )

    p2pC = Mageo::Polar3D.new( 2.0, 0.5*PI,  1.5*PI ).minimize_phi
    assert_in_delta( 1.5*PI, p2pC.phi, $tolerance )

    p2pD = Mageo::Polar3D.new( 2.0, 0.5*PI,  3.5*PI ).minimize_phi
    assert_in_delta( 1.5*PI, p2pD.phi, $tolerance )

    p2pE = Mageo::Polar3D.new( 2.0, 0.5*PI,  5.5*PI ).minimize_phi
    assert_in_delta( 1.5*PI, p2pE.phi, $tolerance )

    p2pF = Mageo::Polar3D.new( 2.0, 0.5*PI,  4.5*PI ).minimize_phi
    assert_in_delta( 0.5*PI, p2pF.phi, $tolerance )

  end
end

