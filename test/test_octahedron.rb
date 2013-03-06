#! /usr/bin/env ruby
# coding: utf-8

require "test/unit"
require "helper"
require 'mageo.rb'
#require "mageo/octahedron.rb"
gem "builtinextension"
  require "array_include_eql.rb"

class Octahedron
  public :center
end

class TC_Octahedron < Test::Unit::TestCase
  $tolerance = 10**(-10)

  V_X_PLUS  = Vector3D[  1,  0,  0 ]
  V_Y_PLUS  = Vector3D[  0,  1,  0 ]
  V_Z_PLUS  = Vector3D[  0,  0,  1 ]

  V_X_MINUS = Vector3D[ -1,  0,  0 ]
  V_Y_MINUS = Vector3D[  0, -1,  0 ]
  V_Z_MINUS = Vector3D[  0,  0, -1 ]

  def setup
    @o00 = Octahedron.new(
      [ [V_X_MINUS, V_X_PLUS ],
        [V_Y_MINUS, V_Y_PLUS ],
        [V_Z_MINUS, V_Z_PLUS ] ]
    )
    @o01 = Octahedron.new(
      [ [ [ -0.5,  0.5,  0.5 ], [  1.5,  0.5,  0.5 ] ],
        [ [  0.5, -0.5,  0.5 ], [  0.5,  1.5,  0.5 ] ],
        [ [  0.5,  0.5, -0.5 ], [  0.5,  0.5,  1.5 ] ] ]
    )
  end

  def test_initialize
    assert_raise( ArgumentError ){ Octahedron.new }
    assert_raise( ArgumentError ){ Octahedron.new() }
    assert_raise( Octahedron::InitializeError ){ Octahedron.new( nil ) }
    assert_raise( Octahedron::InitializeError ){ Octahedron.new( [] ) }
    assert_raise( Octahedron::InitializeError ){ Octahedron.new( [ 0, 1, 2 ] ) }
    assert_raise( Octahedron::InitializeError ){ Octahedron.new( [ [], [], [] ] ) }
    assert_raise( Octahedron::InitializeError ){
      Octahedron.new( 
        [ [ V_X_MINUS, V_X_PLUS ],
          [ V_Y_MINUS, V_Y_PLUS ],
          [ V_Z_MINUS, [  0,  0 ] ]
        ]
      )
    }
    assert_raise( Octahedron::InitializeError ){
      Octahedron.new( 
        [ [ V_X_MINUS, V_X_PLUS],
          [ V_Y_MINUS, [  0,  1,  0, 2 ] ],
          [ V_Z_MINUS, V_Z_PLUS ]
        ]
      )
    }
    assert_raise( Octahedron::InitializeError ){
      Octahedron.new( 
        [ [ V_X_MINUS, V_X_PLUS ],
          [ V_Y_MINUS, V_Y_PLUS ],
          [ V_Z_MINUS, V_Z_PLUS ],
          [ [ -5, -5, -5 ], [  5,  5,  5 ] ]
        ]
      )
    }

    assert_raise( Octahedron::InitializeError ){
      Octahedron.new(
        [ [ Vector3DInternal[ -0.5,  0.5,  0.5 ], Vector3DInternal[  1.5,  0.5,  0.5 ] ],
          [ Vector3DInternal[  0.5, -0.5,  0.5 ], Vector3DInternal[  0.5,  1.5,  0.5 ] ],
          [ Vector3DInternal[  0.5,  0.5, -0.5 ], Vector3DInternal[  0.5,  0.5,  1.5 ] ] ]
      )
    }

    assert_nothing_raised{
      Octahedron.new(
        [ [ Vector3D[ -0.5,  0.5,  0.5 ], Vector3D[  1.5,  0.5,  0.5 ] ],
          [ Vector3D[  0.5, -0.5,  0.5 ], Vector3D[  0.5,  1.5,  0.5 ] ],
          [ Vector3D[  0.5,  0.5, -0.5 ], Vector3D[  0.5,  0.5,  1.5 ] ] ]
      )
    }
  end

  def test_inside?
    assert_equal( true , @o00.inside?( [0.0, 0.2, 0.4] ) )
    assert_equal( false, @o00.inside?( [1.0, 0.0, 0.0] ) ) #境界上
    assert_equal( false, @o00.inside?( [2.0, 0.2, 0.4] ) )
  end

  def test_include?
    assert_equal( true , @o00.include?( [0.0, 0.2, 0.4], $tolerance ) )
    assert_equal( true , @o00.include?( [1.0, 0.0, 0.0], $tolerance ) ) #境界上
    assert_equal( false, @o00.include?( [2.0, 0.2, 0.4], $tolerance ) )
  end

  def test_volume
    assert_in_delta( 8.0/6.0 , @o00.volume, $tolerance )
  end

  def test_center
    assert_in_delta( 0.0, @o00.center[0], $tolerance)
    assert_in_delta( 0.0, @o00.center[1], $tolerance)
    assert_in_delta( 0.0, @o00.center[2], $tolerance)

    assert_in_delta( 0.5, @o01.center[0], $tolerance)
    assert_in_delta( 0.5, @o01.center[1], $tolerance)
    assert_in_delta( 0.5, @o01.center[2], $tolerance)
  end

  def test_vertices
    t = @o00.vertices
    assert_equal(6, t.size)
    assert_equal(true , t.include_eql?(V_X_MINUS))
    assert_equal(true , t.include_eql?(V_X_PLUS ))
    assert_equal(true , t.include_eql?(V_Y_MINUS))
    assert_equal(true , t.include_eql?(V_Y_PLUS ))
    assert_equal(true , t.include_eql?(V_Z_MINUS))
    assert_equal(true , t.include_eql?(V_Z_PLUS ))
  end

  def test_triangles
    t = @o00.triangles
    assert_equal(8, t.size)
    assert_equal(true, t.include_eql?(Triangle.new([V_X_PLUS, V_Y_PLUS, V_Z_PLUS])))
    assert_equal(true, t.include_eql?(Triangle.new([V_X_PLUS, V_Y_PLUS, V_Z_MINUS])))
    assert_equal(true, t.include_eql?(Triangle.new([V_X_PLUS, V_Y_MINUS, V_Z_PLUS])))
    assert_equal(true, t.include_eql?(Triangle.new([V_X_PLUS, V_Y_MINUS, V_Z_MINUS])))
    assert_equal(true, t.include_eql?(Triangle.new([V_X_MINUS, V_Y_PLUS, V_Z_PLUS])))
    assert_equal(true, t.include_eql?(Triangle.new([V_X_MINUS, V_Y_PLUS, V_Z_MINUS])))
    assert_equal(true, t.include_eql?(Triangle.new([V_X_MINUS, V_Y_MINUS, V_Z_PLUS])))
    assert_equal(true, t.include_eql?(Triangle.new([V_X_MINUS, V_Y_MINUS, V_Z_MINUS])))
  end

  def test_edges
    t = @o00.edges
    assert_equal(12, t.size)
    assert_equal(true, (t.include_eql?(Segment.new(V_X_PLUS , V_Y_PLUS))))
    assert_equal(true, (t.include_eql?(Segment.new(V_X_PLUS , V_Y_MINUS))))
    assert_equal(true, (t.include_eql?(Segment.new(V_X_PLUS , V_Z_PLUS))))
    assert_equal(true, (t.include_eql?(Segment.new(V_X_PLUS , V_Z_MINUS))))
    assert_equal(true, (t.include_eql?(Segment.new(V_X_MINUS, V_Y_PLUS))))
    assert_equal(true, (t.include_eql?(Segment.new(V_X_MINUS, V_Y_MINUS))))
    assert_equal(true, (t.include_eql?(Segment.new(V_X_MINUS, V_Z_PLUS))))
    assert_equal(true, (t.include_eql?(Segment.new(V_X_MINUS, V_Z_MINUS))))
    assert_equal(true, (t.include_eql?(Segment.new(V_Y_PLUS , V_Z_PLUS))))
    assert_equal(true, (t.include_eql?(Segment.new(V_Y_PLUS , V_Z_MINUS))))
    assert_equal(true, (t.include_eql?(Segment.new(V_Y_MINUS, V_Z_PLUS))))
    assert_equal(true, (t.include_eql?(Segment.new(V_Y_MINUS, V_Z_MINUS))))
  end
end

