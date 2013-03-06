#! /usr/bin/env ruby
# coding: utf-8

require "helper"
require "test/unit"
#require "mageo/axes.rb"

class TC_Axes < Test::Unit::TestCase
  $tolerance = 1.0 * 10.0**(-10)

  def setup
    @a10 = Mageo::Axes.new([[1.0]])
    @a20 = Mageo::Axes.new([[1.0, 0.0], [0.0, 1.0]])
    @a30 = Mageo::Axes.new([[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]])
    @a40 = Mageo::Axes.new([
        [1.0, 0.0, 0.0, 0.0],
        [0.0, 1.0, 0.0, 0.0],
        [0.0, 0.0, 1.0, 0.0],
        [0.0, 0.0, 0.0, 1.0]
      ]
    )

    @a31 = Mageo::Axes.new( [ [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0] ] )
    @a32 = Mageo::Axes.new( [ [0.5, 0.5, 0.0], [0.5, 0.0, 0.5], [0.0, 0.5, 0.5] ] )
    @a33 = Mageo::Axes.new( [ [1.0, 0.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0] ] )
    @a34 = Mageo::Axes.new( [ [0.5, 0.5, 0.0], [0.5, 0.0, 0.0], [0.0, 0.5, 0.0] ] )
    @a35 = Mageo::Axes.new( [ [1.0, 1.0, 1.0], [0.0, 1.0, 1.0], [0.0, 0.0, 1.0] ] )
    @a36 = Mageo::Axes.new( [ [1.0, 1.0, 1.0], [0.0,-1.0,-1.0], [0.0, 0.0, 1.0] ] )

    @vec_x = Vector[ 1.0, 0.0, 0.0 ]
    @vec_y = Vector[ 0.0, 1.0, 0.0 ]
    @vec_z = Vector[ 0.0, 0.0, 1.0 ]
    @vec_0 = Vector[ 0.0, 0.0, 0.0 ]
    @vec_1 = Vector[ 1.0, 1.0, 0.0 ]
  end

  def test_initialize
    assert_raise(Mageo::Axes::InitializeError) { Mageo::Axes.new([[]]) }
    assert_raise(Mageo::Axes::InitializeError) { Mageo::Axes.new([[1.0, 0.0, 0.0], [0.0, 1.0, 0.0]]) }
    assert_raise(Mageo::Axes::InitializeError) { Mageo::Axes.new([[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 1.0, 1.0]]) }
    assert_raise(Mageo::Axes::InitializeError) { Mageo::Axes.new([[1.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]]) }
    assert_raise(Mageo::Axes::InitializeError) { Mageo::Axes.new([[1.0, 0.0, 0.0], [0.0, 1.0], [0.0, 0.0, 1.0]]) }
    assert_raise(Mageo::Axes::InitializeError) { Mageo::Axes.new([[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0]]) }
    assert_raise(Mageo::Axes::InitializeError) { Mageo::Axes.new([[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0, 0.0]]) }

    assert_nothing_raised{ Mageo::Axes.new([["1.0", "0.0", "0.0"], [0.0, 1.0, 0.0], [0.0, 0.0, 0.0]]) }
    assert_nothing_raised{ Mageo::Axes.new([[1, 0, 0], [0, 1, 0], [0, 0, 0]]) }
  end

  def test_self_dependent?
    # Righthand
    assert_equal( false, Mageo::Axes.dependent?( [ @vec_x, @vec_y, @vec_z ] ) )
    assert_equal( false, Mageo::Axes.dependent?( [ @vec_y, @vec_z, @vec_x ] ) )
    assert_equal( false, Mageo::Axes.dependent?( [ @vec_z, @vec_x, @vec_y ] ) )
    
    # Lefthand
    assert_equal( false, Mageo::Axes.dependent?( [ @vec_z, @vec_y, @vec_x ] ) )
    assert_equal( false, Mageo::Axes.dependent?( [ @vec_x, @vec_z, @vec_y ] ) )
    assert_equal( false, Mageo::Axes.dependent?( [ @vec_y, @vec_x, @vec_z ] ) )
    
    # Including zero vector.
    assert_equal( true , Mageo::Axes.dependent?( [ @vec_0, @vec_y, @vec_z ] ) )
    assert_equal( true , Mageo::Axes.dependent?( [ @vec_0, @vec_z, @vec_x ] ) )
    assert_equal( true , Mageo::Axes.dependent?( [ @vec_0, @vec_x, @vec_y ] ) )

    # One vector is on the plane of residual two vectors.
    assert_equal( true , Mageo::Axes.dependent?( [ @vec_x, @vec_y, @vec_1 ] ) )
  end

  def test_self_independent?
    # Righthand
    assert_equal( true , Mageo::Axes.independent?( [ @vec_x, @vec_y, @vec_z ] ) )
    assert_equal( true , Mageo::Axes.independent?( [ @vec_y, @vec_z, @vec_x ] ) )
    assert_equal( true , Mageo::Axes.independent?( [ @vec_z, @vec_x, @vec_y ] ) )
    
    # Lefthand
    assert_equal( true , Mageo::Axes.independent?( [ @vec_z, @vec_y, @vec_x ] ) )
    assert_equal( true , Mageo::Axes.independent?( [ @vec_x, @vec_z, @vec_y ] ) )
    assert_equal( true , Mageo::Axes.independent?( [ @vec_y, @vec_x, @vec_z ] ) )
    
    # Including zero vector.
    assert_equal( false, Mageo::Axes.independent?( [ @vec_0, @vec_y, @vec_z ] ) )
    assert_equal( false, Mageo::Axes.independent?( [ @vec_0, @vec_z, @vec_x ] ) )
    assert_equal( false, Mageo::Axes.independent?( [ @vec_0, @vec_x, @vec_y ] ) )

    # One vector is on the plane of residual two vectors.
    assert_equal( false, Mageo::Axes.independent?( [ @vec_x, @vec_y, @vec_1 ] ) )
  end

  def test_size
    assert_equal( 1, @a10.size )
    assert_equal( 2, @a20.size )
    assert_equal( 3, @a30.size )
    assert_equal( 4, @a40.size )
  end

  def test_equal
    assert_equal( true , @a31 == Mageo::Axes.new( [ [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0] ] ))
    assert_equal( false, @a31 == Mageo::Axes.new( [ [0.5, 0.5, 0.0], [0.0, 0.5, 0.5], [0.5, 0.0, 0.5] ] ))
    assert_equal( false, @a31 == Mageo::Axes.new( [ [1.0, 1.0, 1.0], [0.0, 1.0, 1.0], [0.0, 0.0, 1.0] ] ))

    assert_equal( false, @a32 == Mageo::Axes.new( [ [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0] ] ))
    assert_equal( true , @a32 == Mageo::Axes.new( [ [0.5, 0.5, 0.0], [0.5, 0.0, 0.5], [0.0, 0.5, 0.5] ] ))
    assert_equal( false, @a32 == Mageo::Axes.new( [ [1.0, 1.0, 1.0], [0.0, 1.0, 1.0], [0.0, 0.0, 1.0] ] ))

    assert_equal( false, @a35 == Mageo::Axes.new( [ [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0] ] ))
    assert_equal( false, @a35 == Mageo::Axes.new( [ [0.5, 0.5, 0.0], [0.0, 0.5, 0.5], [0.5, 0.0, 0.5] ] ))
    assert_equal( true , @a35 == Mageo::Axes.new( [ [1.0, 1.0, 1.0], [0.0, 1.0, 1.0], [0.0, 0.0, 1.0] ] ))
  end

  def test_dependent?
    assert_equal( false, @a31.dependent? )
    assert_equal( false, @a32.dependent? )
    assert_equal( true , @a33.dependent? )
    assert_equal( true , @a34.dependent? )
  end

  def test_independent?
    assert_equal( true , @a31.independent? )
    assert_equal( true , @a32.independent? )
    assert_equal( false, @a33.independent? )
    assert_equal( false, @a34.independent? )
  end

  def test_to_a
    assert_equal( Array, @a31.to_a.class )
    assert_equal( Array, @a31.to_a[0].class )
    assert_equal( Array, @a31.to_a[1].class )
    assert_equal( Array, @a31.to_a[2].class )
    assert_in_delta( 1.0, @a31.to_a[0][0], $tolerance )
    assert_in_delta( 0.0, @a31.to_a[0][1], $tolerance )
    assert_in_delta( 0.0, @a31.to_a[0][2], $tolerance )
    assert_in_delta( 0.0, @a31.to_a[1][0], $tolerance )
    assert_in_delta( 1.0, @a31.to_a[1][1], $tolerance )
    assert_in_delta( 0.0, @a31.to_a[1][2], $tolerance )
    assert_in_delta( 0.0, @a31.to_a[2][0], $tolerance )
    assert_in_delta( 0.0, @a31.to_a[2][1], $tolerance )
    assert_in_delta( 1.0, @a31.to_a[2][2], $tolerance )

    assert_equal( Array, @a35.to_a.class )
    assert_equal( Array, @a35.to_a[0].class )
    assert_equal( Array, @a35.to_a[1].class )
    assert_equal( Array, @a35.to_a[2].class )
    assert_in_delta( 1.0, @a35.to_a[0][0], $tolerance )
    assert_in_delta( 1.0, @a35.to_a[0][1], $tolerance )
    assert_in_delta( 1.0, @a35.to_a[0][2], $tolerance )
    assert_in_delta( 0.0, @a35.to_a[1][0], $tolerance )
    assert_in_delta( 1.0, @a35.to_a[1][1], $tolerance )
    assert_in_delta( 1.0, @a35.to_a[1][2], $tolerance )
    assert_in_delta( 0.0, @a35.to_a[2][0], $tolerance )
    assert_in_delta( 0.0, @a35.to_a[2][1], $tolerance )
    assert_in_delta( 1.0, @a35.to_a[2][2], $tolerance )
  end

  def test_paren # []
    assert_equal( Vector, @a31[0].class )
    assert_equal( Vector, @a31[1].class )
    assert_equal( Vector, @a31[2].class )
    assert_in_delta( 1.0, @a31[0][0], $tolerance )
    assert_in_delta( 0.0, @a31[0][1], $tolerance )
    assert_in_delta( 0.0, @a31[0][2], $tolerance )
    assert_in_delta( 0.0, @a31[1][0], $tolerance )
    assert_in_delta( 1.0, @a31[1][1], $tolerance )
    assert_in_delta( 0.0, @a31[1][2], $tolerance )
    assert_in_delta( 0.0, @a31[2][0], $tolerance )
    assert_in_delta( 0.0, @a31[2][1], $tolerance )
    assert_in_delta( 1.0, @a31[2][2], $tolerance )
  end

  def test_each
    i = 0
    @a31.each { |vec|
      assert_equal( @a31[i], vec )
      i += 1
    }

    assert_raise( NoMethodError ) { @a31.map{ |vec| vec * 2.0 } }
  end

  def test_to_a
    t = @a10.to_a
    assert_equal(Array, t.class)
    assert_equal([[1.0]], t)

    t = @a20.to_a
    assert_equal(Array, t.class)
    assert_equal([[1.0, 0.0], [0.0, 1.0]], t)

    t = @a30.to_a
    assert_equal(Array, t.class)
    assert_equal([[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]] , t)

    t = @a40.to_a
    assert_equal(Array, t.class)
    assert_equal( [
        [1.0, 0.0, 0.0, 0.0],
        [0.0, 1.0, 0.0, 0.0],
        [0.0, 0.0, 1.0, 0.0],
        [0.0, 0.0, 0.0, 1.0]
      ], t
    )

    t = @a32.to_a
    assert_equal(Array, t.class)
    assert_equal( [ [0.5, 0.5, 0.0], [0.5, 0.0, 0.5], [0.0, 0.5, 0.5] ] , t)
  end
end

