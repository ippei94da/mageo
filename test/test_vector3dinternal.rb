#! /usr/bin/ruby

require "helper"
#require 'test/unit'
require 'matrix'
#require 'mageo.rb'
#require 'mageo/vector3d.rb'
#require 'mageo/vector3dinternal.rb'

class TC_Array < Test::Unit::TestCase
  $tolerance = 10.0**(-10)

  def setup
    @a = [1.0, 2.0, 3.0]
  end

  def test_to_v3di
    assert_equal( Mageo::Vector3DInternal, @a.to_v3di.class )
    assert_in_delta( 1.0, @a.to_v3di[0], $tolerance )
    assert_in_delta( 2.0, @a.to_v3di[1], $tolerance )
    assert_in_delta( 3.0, @a.to_v3di[2], $tolerance )
    assert_raise( Mageo::Vector3DInternal::RangeError ){ [1.0].to_v3di }
    assert_raise( Mageo::Vector3DInternal::RangeError ){ [0.0, 1.0, 2.0, 3.0].to_v3di }
  end
end

class TC_Vector3DInternal < Test::Unit::TestCase
  $tolerance = 10.0**(-10)
  include Math

  def setup
    @v0 = Mageo::Vector3DInternal[1.0, 2.0, 3.0]
    @v1 = Mageo::Vector3DInternal[2.0, 4.0, 6.0]
  end

  def test_size
    assert_equal( 3, @v0.size )
    assert_equal( 3, @v1.size )
  end

  def test_to_v3di
    assert_equal( @v0, @v0.to_v3di )
    assert_equal( @v1, @v1.to_v3di )
  end

  def test_equal
    assert_equal( true , @v0 == Mageo::Vector3DInternal[1.0, 2.0, 3.0] )
    assert_equal( true , @v1 == Mageo::Vector3DInternal[2.0, 4.0, 6.0] )
    assert_equal( false, @v0 == Mageo::Vector3DInternal[2.0, 4.0, 6.0] )
    assert_equal( false, @v1 == Mageo::Vector3DInternal[1.0, 2.0, 3.0] )
  end

  def test_class
    assert_equal( Mageo::Vector3DInternal, @v0.class )
    assert_equal( Mageo::Vector3DInternal, ( @v0 * 3.0 ).class )
    assert_equal( Mageo::Vector3DInternal, ( @v0 + @v1 ).class )
    assert_equal( Mageo::Vector3DInternal, ( @v0 - @v1 ).class )
    #assert_equal( Mageo::Vector3DInternal, @v0.clone.class )
    #assert_equal( Mageo::Vector3DInternal, @v0.dup.class )
  end

  def test_access
    assert_equal( 1.0, @v0[0] )
    assert_equal( 2.0, @v0[1] )
    assert_equal( 3.0, @v0[2] )
    assert_raise( Mageo::Vector3DInternal::RangeError ){ @v0[3] }
    assert_raise( Mageo::Vector3DInternal::RangeError ){ @v0[-1] }

    @v0[0] = 0.0
    @v0[1] = 0.0
    @v0[2] = 0.0
    assert_equal( 0.0, @v0[0] )
    assert_equal( 0.0, @v0[1] )
    assert_equal( 0.0, @v0[2] )
    assert_raise( Mageo::Vector3DInternal::RangeError ){ @v0[3] = 0.0 }
    assert_raise( Mageo::Vector3DInternal::RangeError ){ @v0[-1] = 0.0 }
  end

  def test_plus
    assert_raise(Mageo::Vector3DInternal::TypeError){ @v0 + [0.1, 0.2, 0.3] }
    assert_raise(Mageo::Vector3DInternal::TypeError){ @v0 + Vector[0.1, 0.2, 0.3] }
    assert_raise(Mageo::Vector3DInternal::TypeError){ @v0 + Mageo::Vector3D[0.1, 0.2, 0.3] }

    t = @v0 + Mageo::Vector3DInternal[0.1, 0.2, 0.3]
    assert_in_delta( 1.1, t[0], $tolerance )
    assert_in_delta( 2.2, t[1], $tolerance )
    assert_in_delta( 3.3, t[2], $tolerance )
  end

  def test_minus
    assert_raise(Mageo::Vector3DInternal::TypeError){ @v0 - [0.1, 0.2, 0.3] }
    assert_raise(Mageo::Vector3DInternal::TypeError){ @v0 - Vector[0.1, 0.2, 0.3] }
    assert_raise(Mageo::Vector3DInternal::TypeError){ @v0 - Mageo::Vector3D[0.3, 0.2, 0.3] }

    t = @v0 - Mageo::Vector3DInternal[0.1, 0.2, 0.3]
    assert_in_delta( 0.9, t[0], $tolerance )
    assert_in_delta( 1.8, t[1], $tolerance )
    assert_in_delta( 2.7, t[2], $tolerance )
  end

  def test_multiply
    t = @v0 * 2
    assert_in_delta( 2.0, t[0], $tolerance )
    assert_in_delta( 4.0, t[1], $tolerance )
    assert_in_delta( 6.0, t[2], $tolerance )

    t = @v0 * 3.0
    assert_in_delta( 3.0, t[0], $tolerance )
    assert_in_delta( 6.0, t[1], $tolerance )
    assert_in_delta( 9.0, t[2], $tolerance )

  end

  #def test_equal
  # assert_equal(  )
  #end

  def test_to_a
    assert_equal( [1.0, 2.0, 3.0], @v0.to_a )
    assert_equal( [2.0, 4.0, 6.0], @v1.to_a )
  end

  def test_to_v3d
    t = Mageo::Vector3DInternal[ 2.0, 3.0, 4.0 ].to_v3d( [ [1.0, 1.0, 1.0], [0.0, 1.0, 1.0], [0.0, 0.0, 1.0] ] )
    assert_in_delta( 2.0, t[0], $tolerance )
    assert_in_delta( 5.0, t[1], $tolerance )
    assert_in_delta( 9.0, t[2], $tolerance )

    t = Mageo::Vector3DInternal[ 2.0, 3.0, 4.0 ].to_v3d(
      [ Mageo::Vector3D[1.0, 1.0, 1.0], Mageo::Vector3D[0.0, 1.0, 1.0], Mageo::Vector3D[0.0, 0.0, 1.0] ]
    )
    assert_in_delta( 2.0, t[0], $tolerance )
    assert_in_delta( 5.0, t[1], $tolerance )
    assert_in_delta( 9.0, t[2], $tolerance )
  end

  def test_each
    i = 0
    @v0.each { |coord|
      assert_equal( @v0[i], coord )
      i += 1
    }

    # map method.
    assert_equal( @v0 * 2.0, @v0.map { |coord| coord * 2.0 } )
  end
end

