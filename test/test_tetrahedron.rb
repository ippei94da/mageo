#! /usr/bin/env ruby
# coding: utf-8

require "helper"
#require "test/unit"
#require "rubygems"
#gem "builtinextension"
#require "array/includeeql.rb"
#require 'mageo.rb'
#require "mageo/tetrahedron.rb"

class Mageo::Tetrahedron
  public :center
end

class TC_Tetrahedron < Test::Unit::TestCase
  $tolerance = 10**(-10)

  V_00 = Mageo::Vector3D[ 0.0, 0.0, 0.0]
  V_01 = Mageo::Vector3D[10.0, 0.0, 0.0]
  V_02 = Mageo::Vector3D[ 0.0,10.0, 0.0]
  V_03 = Mageo::Vector3D[ 0.0, 0.0,10.0]

  V_10 = Mageo::Vector3D[10.0,20.0,30.0]
  V_11 = Mageo::Vector3D[ 0.0,20.0,30.0]
  V_12 = Mageo::Vector3D[10.0, 0.0,30.0]
  V_13 = Mageo::Vector3D[10.0,20.0, 0.0]

  def setup
    @t00 = Mageo::Tetrahedron.new( [ V_00, V_01, V_02, V_03 ])
    @t01 = Mageo::Tetrahedron.new( [ V_10, V_11, V_12, V_13 ])
  end

  def test_initialize
    assert_raise( ArgumentError ){ Mageo::Tetrahedron.new }
    assert_raise( ArgumentError ){ Mageo::Tetrahedron.new() }
    assert_raise( Mageo::Tetrahedron::InitializeError ){ Mageo::Tetrahedron.new( nil ) }
    assert_raise( Mageo::Tetrahedron::InitializeError ){ Mageo::Tetrahedron.new( [] ) }
    assert_raise( Mageo::Tetrahedron::InitializeError ){ Mageo::Tetrahedron.new( [ 0, 1, 2, 3 ] ) }
    assert_raise( Mageo::Tetrahedron::InitializeError ){ Mageo::Tetrahedron.new( [ [], [], [], [] ] ) }
    assert_raise( Mageo::Tetrahedron::InitializeError ){
      Mageo::Tetrahedron.new( [ V_00, V_01, V_02, [ 0.0, 0.0 ] ])
    }
    assert_raise( Mageo::Tetrahedron::InitializeError ){
      Mageo::Tetrahedron.new( [ V_00, V_01, V_02, [ 0.0, 0.0, 1.0, 0.0 ] ])
    }

    # 5点ある
    assert_raise( Mageo::Tetrahedron::InitializeError ){
      Mageo::Tetrahedron.new( [ V_00, V_01, V_02, V_03, [ 1.0, 1.0, 1.0] ])
    }
  
    # 体積が 0.0 になるのはエラー
    assert_raise( Mageo::Tetrahedron::InitializeError ){
      Mageo::Tetrahedron.new( [ V_00, V_01, V_02, [ 2.0, 2.0, 0.0] ])
    }

    # Mageo::Vector3DInternal なら 例外
    assert_raise( Mageo::Tetrahedron::InitializeError ){
      Mageo::Tetrahedron.new( 
        [ Mageo::Vector3DInternal[ 0.0, 0.0, 0.0],
          Mageo::Vector3DInternal[ 1.0, 0.0, 0.0],
          Mageo::Vector3DInternal[ 0.0, 1.0, 0.0],
          Mageo::Vector3DInternal[ 0.0, 0.0, 1.0]
        ]
      )
    }
  
    # Mageo::Vector3D なら OK
    assert_nothing_raised{
      Mageo::Tetrahedron.new( [ V_00, V_01, V_02, V_03 ])
    }
  end

  def test_inside?
    assert_equal( true , @t00.inside?( [ 1.0, 1.0, 1.0] ) )
    assert_equal( false, @t00.inside?( [ 5.0, 5.0, 5.0] ) )
    assert_equal( false, @t00.inside?( [-5.0,-5.0,-5.0] ) )
    assert_equal( false, @t00.inside?( [ 0.0, 0.0, 0.0] ) ) #頂点上

    assert_raise(Mageo::Polyhedron::TypeError){@t00.inside?(Mageo::Vector3DInternal[1.0, 1.0, 1.0])}
    assert_raise(Mageo::Tetrahedron::TypeError){@t00.inside?(Mageo::Vector3DInternal[1.0, 1.0, 1.0])}
    #pp Mageo::Polyhedron::TypeError.ancestors
    #pp Mageo::Tetrahedron::TypeError.ancestors
  end

  def test_include?
    assert_equal( true , @t00.include?([ 1.0, 1.0, 1.0], $tolerance))
    assert_equal( false, @t00.include?([ 5.0, 5.0, 5.0], $tolerance))
    assert_equal( false, @t00.include?([-5.0,-5.0,-5.0], $tolerance))
    assert_equal( true , @t00.include?([ 0.0, 0.0, 0.0], $tolerance)) #頂点上

    assert_equal( false, @t01.include?(Mageo::Vector3D[ 3.0, 6.0, 30.0], $tolerance))

    assert_raise(Mageo::Polyhedron::TypeError){@t00.include?(Mageo::Vector3DInternal[1.0, 1.0, 1.0], $tolerance)}
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
    assert_equal(Mageo::Triangle.new([V_00, V_01, V_02]) ,t[0])
    assert_equal(Mageo::Triangle.new([V_01, V_02, V_03]) ,t[1])
    assert_equal(Mageo::Triangle.new([V_02, V_03, V_00]) ,t[2])
    assert_equal(Mageo::Triangle.new([V_03, V_00, V_01]) ,t[3])
  end

  def test_edges
    t = @t00.edges
    assert_equal(6, t.size)
    assert_equal(true, (t.include_eql?(Mageo::Segment.new(V_00, V_01))))
    assert_equal(true, (t.include_eql?(Mageo::Segment.new(V_00, V_02))))
    assert_equal(true, (t.include_eql?(Mageo::Segment.new(V_00, V_03))))
    assert_equal(true, (t.include_eql?(Mageo::Segment.new(V_01, V_02))))
    assert_equal(true, (t.include_eql?(Mageo::Segment.new(V_01, V_03))))
    assert_equal(true, (t.include_eql?(Mageo::Segment.new(V_02, V_03))))
  end


  def test_translate!
    @t00.translate!(Mageo::Vector3D[ 5.0, 6.0, -7.0])
    assert_in_delta( 5.0, @t00.vertices[0][0], $tolerance)
    assert_in_delta( 6.0, @t00.vertices[0][1], $tolerance)
    assert_in_delta(-7.0, @t00.vertices[0][2], $tolerance)
    assert_in_delta(15.0, @t00.vertices[1][0], $tolerance)
    assert_in_delta( 6.0, @t00.vertices[1][1], $tolerance)
    assert_in_delta(-7.0, @t00.vertices[1][2], $tolerance)
    assert_in_delta( 5.0, @t00.vertices[2][0], $tolerance)
    assert_in_delta(16.0, @t00.vertices[2][1], $tolerance)
    assert_in_delta(-7.0, @t00.vertices[2][2], $tolerance)
    assert_in_delta( 5.0, @t00.vertices[3][0], $tolerance)
    assert_in_delta( 6.0, @t00.vertices[3][1], $tolerance)
    assert_in_delta( 3.0, @t00.vertices[3][2], $tolerance)
  end

  def test_translate
    result = @t00.translate(Mageo::Vector3D[ 5.0, 6.0, -7.0])
    assert_in_delta( 5.0, result.vertices[0][0], $tolerance)
    assert_in_delta( 6.0, result.vertices[0][1], $tolerance)
    assert_in_delta(-7.0, result.vertices[0][2], $tolerance)
    assert_in_delta(15.0, result.vertices[1][0], $tolerance)
    assert_in_delta( 6.0, result.vertices[1][1], $tolerance)
    assert_in_delta(-7.0, result.vertices[1][2], $tolerance)
    assert_in_delta( 5.0, result.vertices[2][0], $tolerance)
    assert_in_delta(16.0, result.vertices[2][1], $tolerance)
    assert_in_delta(-7.0, result.vertices[2][2], $tolerance)
    assert_in_delta( 5.0, result.vertices[3][0], $tolerance)
    assert_in_delta( 6.0, result.vertices[3][1], $tolerance)
    assert_in_delta( 3.0, result.vertices[3][2], $tolerance)

    assert_in_delta( 0.0, @t00.vertices[0][0], $tolerance)
    assert_in_delta( 0.0, @t00.vertices[0][1], $tolerance)
    assert_in_delta( 0.0, @t00.vertices[0][2], $tolerance)
    assert_in_delta(10.0, @t00.vertices[1][0], $tolerance)
    assert_in_delta( 0.0, @t00.vertices[1][1], $tolerance)
    assert_in_delta( 0.0, @t00.vertices[1][2], $tolerance)
    assert_in_delta( 0.0, @t00.vertices[2][0], $tolerance)
    assert_in_delta(10.0, @t00.vertices[2][1], $tolerance)
    assert_in_delta( 0.0, @t00.vertices[2][2], $tolerance)
    assert_in_delta( 0.0, @t00.vertices[3][0], $tolerance)
    assert_in_delta( 0.0, @t00.vertices[3][1], $tolerance)
    assert_in_delta(10.0, @t00.vertices[3][2], $tolerance)
  end

  def test_shared_vertices
    v123 = Mageo::Vector3D[ 1.0, 2.0, 3.0]
    v234 = Mageo::Vector3D[ 2.0, 3.0, 4.0]
    v346 = Mageo::Vector3D[ 3.0, 4.0, 6.0]
    v859 = Mageo::Vector3D[ 8.0, 5.0, 9.0]

    # Mismatch is only the order of vertices.
    t11 = Mageo::Tetrahedron.new( [ V_01, V_02, V_03, V_00 ])
    results = @t00.shared_vertices(t11)
    assert_equal([ V_00, V_01, V_02, V_03 ], results)

    t11 = Mageo::Tetrahedron.new([V_01, V_02, v123, V_00])
    results = @t00.shared_vertices(t11)
    assert_equal([V_00, V_01, V_02], results)

    t11 = Mageo::Tetrahedron.new([V_01, v234, v123, V_00])
    results = @t00.shared_vertices(t11)
    assert_equal([V_00, V_01], results)

    t11 = Mageo::Tetrahedron.new([v346, v234, v123, V_00])
    results = @t00.shared_vertices(t11)
    assert_equal([V_00], results)

    t11 = Mageo::Tetrahedron.new([v346, v234, v123, v859])
    results = @t00.shared_vertices(t11)
    assert_equal([], results)

    v00a = Mageo::Vector3D[ 0.0+1.0E-13, 0.0+1.0E-13, 0.0+1.0E-13]
    v01a = Mageo::Vector3D[10.0+1.0E-13, 0.0+1.0E-13, 0.0+1.0E-13]
    v02a = Mageo::Vector3D[ 0.0+1.0E-13,10.0+1.0E-13, 0.0+1.0E-13]
    v03a = Mageo::Vector3D[ 0.0+1.0E-13, 0.0+1.0E-13,10.0+1.0E-13]
    t11 = Mageo::Tetrahedron.new( [ v01a, v02a, v03a, v00a ])
    results = @t00.shared_vertices(t11)
    assert_equal([], results)
    results = @t00.shared_vertices(t11, 1.0E-10)
    assert_equal([ V_00, V_01, V_02, V_03 ], results)
  end

end

