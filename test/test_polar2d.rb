#! /usr/bin/env ruby
# coding: utf-8

require "test/unit"
require "helper"
require "mageo/vector.rb"
require "mageo/polar2d.rb"


class TC_Vector < Test::Unit::TestCase
  include Math

  $tolerance = 10.0**(-10)

  def setup
    @v0 = Vector[ 1.0, 2.0, 3.0 ]
    @v1 = Vector[ 1.0, 1.0 ]
    @v2 = Vector[ 1.0, 2.0, 3.0, 4.0 ]
  end

  def test_to_p2d
    assert_raise( Vector::SizeError ){ @v0.to_p2d }
    assert_raise( Vector::SizeError ){ @v2.to_p2d }
    assert_equal( Polar2D        , @v1.to_p2d.class )
    assert_equal( Math::sqrt(2.0), @v1.to_p2d.r )
    assert_equal( 0.25*PI        , @v1.to_p2d.theta )

    assert_in_delta( 0.00*PI, Vector[  0.0,  0.0 ].to_p2d.theta, $tolerance )
    assert_in_delta( 0.00*PI, Vector[  2.0,  0.0 ].to_p2d.theta, $tolerance )
    assert_in_delta( 0.25*PI, Vector[  2.0,  2.0 ].to_p2d.theta, $tolerance )
    assert_in_delta( 0.50*PI, Vector[  0.0,  2.0 ].to_p2d.theta, $tolerance )
    assert_in_delta( 0.75*PI, Vector[ -2.0,  2.0 ].to_p2d.theta, $tolerance )
    assert_in_delta( 1.00*PI, Vector[ -2.0,  0.0 ].to_p2d.theta, $tolerance )
    assert_in_delta( 1.25*PI, Vector[ -2.0, -2.0 ].to_p2d.theta, $tolerance )
    assert_in_delta( 1.50*PI, Vector[  0.0, -2.0 ].to_p2d.theta, $tolerance )
    assert_in_delta( 1.75*PI, Vector[  2.0, -2.0 ].to_p2d.theta, $tolerance )
  end
end


class TC_Polar2D < Test::Unit::TestCase
  $tolerance = 10**(-10)

  include Math

  def setup
    @p2d00 = Polar2D.new( 0.0, 0.0*PI)
    @p2d01 = Polar2D.new( 0.0, 2.0*PI)
    @p2d02 = Polar2D.new( 2.0, 0.0*PI)
    @p2d03 = Polar2D.new( 2.0, 0.1*PI)
  end

  def test_to_v
    assert_equal( Vector[ 0.0, 0.0 ], @p2d00.to_v )
    assert_equal( Vector[ 0.0, 0.0 ], @p2d01.to_v )
    assert_equal( Vector[ 2.0, 0.0 ], @p2d02.to_v )
    assert_equal( Vector[ 2.0*cos(0.1*PI), 2.0*sin(0.1*PI) ], @p2d03.to_v )
  end

  def test_rotate
    assert_equal( Polar2D, @p2d00.rotate( 0.2 * PI ).class )

    assert_in_delta( 0.0   , @p2d00.rotate( 0.2 * PI ).r    , $tolerance )
    assert_in_delta( 0.2*PI, @p2d00.rotate( 0.2 * PI ).theta, $tolerance )
    assert_in_delta( 0.0   , @p2d01.rotate( 0.2 * PI ).r    , $tolerance )
    assert_in_delta( 2.2*PI, @p2d01.rotate( 0.2 * PI ).theta, $tolerance )
    assert_in_delta( 2.0   , @p2d02.rotate( 0.2 * PI ).r    , $tolerance )
    assert_in_delta( 0.2*PI, @p2d02.rotate( 0.2 * PI ).theta, $tolerance )
    assert_in_delta( 2.0   , @p2d03.rotate( 0.2 * PI ).r    , $tolerance )
    assert_in_delta( 0.3*PI, @p2d03.rotate( 0.2 * PI ).theta, $tolerance )

    #変化していないことを確認
    assert_equal( Vector[ 0.0, 0.0 ], @p2d00.to_v )
    assert_equal( Vector[ 0.0, 0.0 ], @p2d01.to_v )
    assert_equal( Vector[ 2.0, 0.0 ], @p2d02.to_v )
    assert_equal( Vector[ 2.0*cos(0.1*PI), 2.0*sin(0.1*PI) ], @p2d03.to_v )
  end

  def test_rotate!
    @p2d00.rotate!( 0.2 * PI )
    @p2d01.rotate!( 0.2 * PI )
    @p2d02.rotate!( 0.2 * PI )
    @p2d03.rotate!( 0.2 * PI )

    assert_in_delta( 0.0   , @p2d00.r    , $tolerance )
    assert_in_delta( 0.2*PI, @p2d00.theta, $tolerance )
    assert_in_delta( 0.0   , @p2d01.r    , $tolerance )
    assert_in_delta( 2.2*PI, @p2d01.theta, $tolerance )
    assert_in_delta( 2.0   , @p2d02.r    , $tolerance )
    assert_in_delta( 0.2*PI, @p2d02.theta, $tolerance )
    assert_in_delta( 2.0   , @p2d03.r    , $tolerance )
    assert_in_delta( 0.3*PI, @p2d03.theta, $tolerance )
  end

  def test_minimize_theta!
    p2pA = Polar2D.new( 2.0, -2.5*PI )
    p2pA.minimize_theta!
    assert_in_delta( 1.5*PI, p2pA.theta, $tolerance )

    p2pB = Polar2D.new( 2.0, -0.5*PI )
    p2pB.minimize_theta!
    assert_in_delta( 1.5*PI, p2pB.theta, $tolerance )

    p2pC = Polar2D.new( 2.0,  1.5*PI )
    p2pC.minimize_theta!
    assert_in_delta( 1.5*PI, p2pC.theta, $tolerance )

    p2pD = Polar2D.new( 2.0,  3.5*PI )
    p2pD.minimize_theta!
    assert_in_delta( 1.5*PI, p2pD.theta, $tolerance )

    p2pE = Polar2D.new( 2.0,  5.5*PI )
    p2pE.minimize_theta!
    assert_in_delta( 1.5*PI, p2pE.theta, $tolerance )

    p2pF = Polar2D.new( 2.0,  4.5*PI )
    p2pF.minimize_theta!
    assert_in_delta( 0.5*PI, p2pF.theta, $tolerance )

  end

  def test_minimize_theta
    p2pA = Polar2D.new( 2.0, -2.5*PI ).minimize_theta
    assert_in_delta( 1.5*PI, p2pA.theta, $tolerance )

    p2pB = Polar2D.new( 2.0, -0.5*PI ).minimize_theta
    assert_in_delta( 1.5*PI, p2pB.theta, $tolerance )

    p2pC = Polar2D.new( 2.0,  1.5*PI ).minimize_theta
    assert_in_delta( 1.5*PI, p2pC.theta, $tolerance )

    p2pD = Polar2D.new( 2.0,  3.5*PI ).minimize_theta
    assert_in_delta( 1.5*PI, p2pD.theta, $tolerance )

    p2pE = Polar2D.new( 2.0,  5.5*PI ).minimize_theta
    assert_in_delta( 1.5*PI, p2pE.theta, $tolerance )

    p2pF = Polar2D.new( 2.0,  4.5*PI ).minimize_theta
    assert_in_delta( 0.5*PI, p2pF.theta, $tolerance )

  end

  def test_minimum_radian
    assert_in_delta( 1.5*PI, Polar2D.minimum_radian( -2.5*PI ), $tolerance )
    assert_in_delta( 1.5*PI, Polar2D.minimum_radian( -0.5*PI ), $tolerance )
    assert_in_delta( 1.5*PI, Polar2D.minimum_radian(  1.5*PI ), $tolerance )
    assert_in_delta( 1.5*PI, Polar2D.minimum_radian(  3.5*PI ), $tolerance )
    assert_in_delta( 0.5*PI, Polar2D.minimum_radian(  4.5*PI ), $tolerance )
    assert_in_delta( 1.5*PI, Polar2D.minimum_radian(  5.5*PI ), $tolerance )
  end

end

