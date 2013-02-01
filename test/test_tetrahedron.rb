#! /usr/bin/env ruby
# coding: utf-8

require "test/unit"
require "rubygems"
gem "builtinextension"
require "array_include_eql.rb"
require "mageo/tetrahedron.rb"

class Tetrahedron
  public :center
end

class TC_Tetrahedron < Test::Unit::TestCase
  $tolerance = 10**(-10)

  V_00 = Vector3D[ 0.0, 0.0, 0.0]
  V_01 = Vector3D[10.0, 0.0, 0.0]
  V_02 = Vector3D[ 0.0,10.0, 0.0]
  V_03 = Vector3D[ 0.0, 0.0,10.0]

  V_10 = Vector3D[10.0,20.0,30.0]
  V_11 = Vector3D[ 0.0,20.0,30.0]
  V_12 = Vector3D[10.0, 0.0,30.0]
  V_13 = Vector3D[10.0,20.0, 0.0]

  def setup
    @t00 = Tetrahedron.new( [ V_00, V_01, V_02, V_03 ])
    @t01 = Tetrahedron.new( [ V_10, V_11, V_12, V_13 ])
  end

  def test_initialize
    assert_raise( ArgumentError ){ Tetrahedron.new }
    assert_raise( ArgumentError ){ Tetrahedron.new() }
    assert_raise( Tetrahedron::InitializeError ){ Tetrahedron.new( nil ) }
    assert_raise( Tetrahedron::InitializeError ){ Tetrahedron.new( [] ) }
    assert_raise( Tetrahedron::InitializeError ){ Tetrahedron.new( [ 0, 1, 2, 3 ] ) }
    assert_raise( Tetrahedron::InitializeError ){ Tetrahedron.new( [ [], [], [], [] ] ) }
    assert_raise( Tetrahedron::InitializeError ){
      Tetrahedron.new( [ V_00, V_01, V_02, [ 0.0, 0.0 ] ])
    }
    assert_raise( Tetrahedron::InitializeError ){
      Tetrahedron.new( [ V_00, V_01, V_02, [ 0.0, 0.0, 1.0, 0.0 ] ])
    }

    # 5点ある
    assert_raise( Tetrahedron::InitializeError ){
      Tetrahedron.new( [ V_00, V_01, V_02, V_03, [ 1.0, 1.0, 1.0] ])
    }
  
    # 体積が 0.0 になるのはエラー
    assert_raise( Tetrahedron::InitializeError ){
      Tetrahedron.new( [ V_00, V_01, V_02, [ 2.0, 2.0, 0.0] ])
    }

    # Vector3DInternal なら 例外
    assert_raise( Tetrahedron::InitializeError ){
      Tetrahedron.new( 
        [ Vector3DInternal[ 0.0, 0.0, 0.0],
          Vector3DInternal[ 1.0, 0.0, 0.0],
          Vector3DInternal[ 0.0, 1.0, 0.0],
          Vector3DInternal[ 0.0, 0.0, 1.0]
        ]
      )
    }
  
    # Vector3D なら OK
    assert_nothing_raised{
      Tetrahedron.new( [ V_00, V_01, V_02, V_03 ])
    }
  end

  def test_inside?
    assert_equal( true , @t00.inside?( [ 1.0, 1.0, 1.0] ) )
    assert_equal( false, @t00.inside?( [ 5.0, 5.0, 5.0] ) )
    assert_equal( false, @t00.inside?( [-5.0,-5.0,-5.0] ) )
    assert_equal( false, @t00.inside?( [ 0.0, 0.0, 0.0] ) ) #頂点上

    assert_raise(Polyhedron::TypeError){@t00.inside?(Vector3DInternal[1.0, 1.0, 1.0])}
    assert_raise(Tetrahedron::TypeError){@t00.inside?(Vector3DInternal[1.0, 1.0, 1.0])}
    #pp Polyhedron::TypeError.ancestors
    #pp Tetrahedron::TypeError.ancestors
  end

  def test_include?
    assert_equal( true , @t00.include?([ 1.0, 1.0, 1.0], $tolerance))
    assert_equal( false, @t00.include?([ 5.0, 5.0, 5.0], $tolerance))
    assert_equal( false, @t00.include?([-5.0,-5.0,-5.0], $tolerance))
    assert_equal( true , @t00.include?([ 0.0, 0.0, 0.0], $tolerance)) #頂点上

    assert_equal( false, @t01.include?(Vector3D[ 3.0, 6.0, 30.0], $tolerance))

    assert_raise(Polyhedron::TypeError){@t00.include?(Vector3DInternal[1.0, 1.0, 1.0], $tolerance)}
  end

  def test_volume
    assert_in_delta( 1000.0/6.0 , @t00.volume, $tolerance )
  end

  def test_center
    assert_in_delta( 10.0/4.0, @t00.center[0], $tolerance)
    assert_in_delta( 10.0/4.0, @t00.center[1], $tolerance)
    assert_in_delta( 10.0/4.0, @t00.center[2], $tolerance)
  end

  def test_vertices
    assert_equal( [ V_00, V_01, V_02, V_03 ], @t00.vertices)
  end

  def test_triangles
    t = @t00.triangles
    assert_equal(4, t.size)
    assert_equal(Triangle.new([V_00, V_01, V_02]) ,t[0])
    assert_equal(Triangle.new([V_01, V_02, V_03]) ,t[1])
    assert_equal(Triangle.new([V_02, V_03, V_00]) ,t[2])
    assert_equal(Triangle.new([V_03, V_00, V_01]) ,t[3])
  end

  def test_edges
    t = @t00.edges
    assert_equal(6, t.size)
    assert_equal(true, (t.include_eql?(Segment.new(V_00, V_01))))
    assert_equal(true, (t.include_eql?(Segment.new(V_00, V_02))))
    assert_equal(true, (t.include_eql?(Segment.new(V_00, V_03))))
    assert_equal(true, (t.include_eql?(Segment.new(V_01, V_02))))
    assert_equal(true, (t.include_eql?(Segment.new(V_01, V_03))))
    assert_equal(true, (t.include_eql?(Segment.new(V_02, V_03))))
  end


end

