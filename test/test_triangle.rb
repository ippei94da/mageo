#! /usr/bin/env ruby
# coding: utf-8

require "test/unit"
require "mageo/triangle.rb"
require "mageo/vector3d.rb"

class Triangle
	public :internal_axes
end

class TC_Triangle < Test::Unit::TestCase
	$tolerance = 10.0 ** (-10)

	VEC_O = Vector3D[0.0, 0.0, 0.0]
	VEC_X = Vector3D[1.0, 0.0, 0.0]
	VEC_Y = Vector3D[0.0, 1.0, 0.0]
	VEC_Z = Vector3D[0.0, 0.0, 1.0]

	def setup
		@t00 = Triangle.new([VEC_O, VEC_X, VEC_Y])
		@t01 = Triangle.new([VEC_X, VEC_Y, VEC_Z])
		@t02 = Triangle.new([[10.0,10.0,10.0], [20.0,10.0,10.0], [10.0,20.0,10.0]])
		@t03 = Triangle.new([[10.0,20.0,30.0], [ 0.0,20.0,30.0], [10.0, 0.0,30.0]])
	end

	def test_initialize
		assert_raise( ArgumentError ){ Triangle.new }
		assert_raise( ArgumentError ){ Triangle.new() }
		assert_raise( Triangle::InitializeError ){ Triangle.new( nil ) }
		assert_raise( Triangle::InitializeError ){ Triangle.new( [] ) }
		assert_raise( Triangle::InitializeError ){ Triangle.new( [ 0, 1 ] ) }
		assert_raise( Triangle::InitializeError ){ Triangle.new( [ 0, 1, 2 ] ) }
		assert_raise( Triangle::InitializeError ){ Triangle.new( [ 0, 1, 2, 3 ] ) } 
		assert_raise( Triangle::InitializeError ){ Triangle.new( [ [ 0, 0, 0 ], [ 1, 1, 1 ], [ 2, 3 ] ] ) } #3次元座標になっていないものがある。

		assert_raise( Triangle::LinearException ){ Triangle.new( [ [ 0, 0, 0 ], [ 0, 0, 0 ], [ 2, 2, 2 ] ] ) } #同一の点を含む。
		assert_raise( Triangle::LinearException ){ Triangle.new( [ [ 0, 0, 0 ], [ 1, 1, 1 ], [ 2, 2, 2 ] ] ) } #直線上に並ぶ

		assert_equal( Triangle, Triangle.new( [ Vector3D[ 0, 0, 0 ], Vector3D[ 1, 0, 0 ], Vector3D[ 0, 1, 0 ] ] ).class )
	end

	def test_vertices
		assert_equal( Array, @t00.vertices.class )
		assert_equal( 3, @t00.vertices.size )
		assert_equal( Vector3D[0, 0, 0], @t00.vertices[0] )
		assert_equal( Vector3D[1, 0, 0], @t00.vertices[1] )
		assert_equal( Vector3D[0, 1, 0], @t00.vertices[2] )
	end

	def test_same_side?
		assert_raise(Triangle::TypeError){ @t00.same_side?( [ 2, 3,  7 ], [ -2, -3,  2 ])}

		assert_equal( true , @t00.same_side?( Vector3D[ 2, 3,  7 ], Vector3D[ -2, -3,  2 ] ) )
		assert_equal( true , @t00.same_side?( Vector3D[ 2, 3, -7 ], Vector3D[ -2, -3, -2 ] ) )
		assert_equal( false, @t00.same_side?( Vector3D[ 2, 3,  7 ], Vector3D[ -2, -3, -2 ] ) )
		assert_equal( false, @t00.same_side?( Vector3D[ 2, 3, -7 ], Vector3D[ -2, -3,  2 ] ) )
		assert_equal( false, @t00.same_side?( Vector3D[ 1, 2,  0 ], Vector3D[ 10, 10, 10 ] ) ) #pos0 が面上の点
		assert_equal( false, @t00.same_side?( Vector3D[10, 10,10 ], Vector3D[  1,  2,  0 ] ) ) #pos1 が面上の点
		assert_equal( false, @t00.same_side?( Vector3D[10, 10, 0 ], Vector3D[  1,  2,  0 ] ) )   #両方 が面上の点

		assert_equal( true , @t01.same_side?( Vector3D[  10,  10, 10 ], Vector3D[  20,  30,  40 ] ) )
		assert_equal( true , @t01.same_side?( Vector3D[   0,   0,  0 ], Vector3D[ -10, -10, -10 ] ) )
		assert_equal( false, @t01.same_side?( Vector3D[  10,  10, 10 ], Vector3D[ -10, -10, -10 ] ) )
		assert_equal( false, @t01.same_side?( Vector3D[   0,   0,  0 ], Vector3D[  20,  30,  40 ] ) )
		assert_equal( false, @t01.same_side?( Vector3D[ 0.5, 0.5,  0 ], Vector3D[  10,  10,  10 ] ) ) #pos0 が面上の点
		assert_equal( false, @t01.same_side?( Vector3D[  10,  10, 10 ], Vector3D[ 0.5, 0.5,   0 ] ) ) #pos1 が面上の点
		assert_equal( false, @t01.same_side?( Vector3D[ 0.5, 0.5,  0 ], Vector3D[   0, 0.5, 0.5 ] ) ) #両方 が面上の点
	end

	def test_include?
		assert_raise(Triangle::TypeError){ @t00.include?([11.0, 11.0, 10.0], $tolerance)}

		# on face
		assert_equal(true, @t02.include?(Vector3D[11.0, 11.0, 10.0], $tolerance))

		# on vertices
		assert_equal(true, @t02.include?(Vector3D[10.0, 10.0, 10.0], $tolerance))
		assert_equal(true, @t02.include?(Vector3D[20.0, 10.0, 10.0], $tolerance))
		assert_equal(true, @t02.include?(Vector3D[10.0, 20.0, 10.0], $tolerance))

		# on edge
		assert_equal(true, @t02.include?(Vector3D[15.0, 10.0, 10.0], $tolerance))
		assert_equal(true, @t02.include?(Vector3D[10.0, 15.0, 10.0], $tolerance))
		assert_equal(true, @t02.include?(Vector3D[15.0, 15.0, 10.0], $tolerance))

		# out
		assert_equal(false, @t02.include?(Vector3D[ 30.0, 10.0, 10.0], $tolerance))
		assert_equal(false, @t02.include?(Vector3D[ 10.0, 30.0, 10.0], $tolerance))
		assert_equal(false, @t02.include?(Vector3D[-10.0, 10.0, 10.0], $tolerance))
		assert_equal(false, @t02.include?(Vector3D[ 10.0,-10.0, 10.0], $tolerance))
		assert_equal(false, @t02.include?(Vector3D[ 10.0, 10.0,  0.0], $tolerance))

		assert_equal(false, @t03.include?(Vector3D[  3.0,  6.0, 30.0], $tolerance))

		# 計算誤差
		assert_equal(false, @t01.include?(Vector3D[  0.3,  0.3,  0.3], $tolerance))
		assert_equal(true, @t01.include?(Vector3D[  0.3,  0.3,  0.3], 1.0))
	end

	def test_intersection
		# 平行
		pos0 = Vector3D[0.0, 0.0, 2.0]
		pos1 = Vector3D[2.0, 0.0, 2.0]
		seg01 = Segment.new(pos0, pos1)
		assert_raise(Triangle::NoIntersectionError){ @t00.intersection(seg01, $tolerance) }

		# 面に含まれる
		pos0 = Vector3D[0.0, 0.0, 0.0]
		pos1 = Vector3D[2.0, 0.0, 0.0]
		seg01 = Segment.new(pos0, pos1)
		assert_raise(Triangle::NoIntersectionError){ @t00.intersection(seg01, $tolerance) }

		# 平行ではないが、三角形の外を通過。
		pos2 = Vector3D[0.0,10.0, 0.0]
		pos3 = Vector3D[0.0,10.0, 2.0]
		seg01 = Segment.new(pos0, pos1)
		assert_raise(Triangle::NoIntersectionError){ @t00.intersection(seg01, $tolerance) }

		# 三角形を通る
		pos2 = Vector3D[0.5, 0.5,-1.0]
		pos3 = Vector3D[0.5, 0.5, 2.0]
		seg01 = Segment.new(pos2, pos3)
		assert_equal(Vector3D[0.5, 0.5, 0.0], @t00.intersection(seg01, $tolerance))
		#
		pos2 = Vector3D[0.5, 0.5, 0.0]
		pos3 = Vector3D[0.5, 0.5, 1.0]
		seg01 = Segment.new(pos2, pos3)
		assert_equal(Vector3D[0.5, 0.5, 0.0], @t00.intersection(seg01, $tolerance))
		#
		pos2 = Vector3D[ 1.5, 1.5, 1.0]
		pos3 = Vector3D[-0.5,-0.5,-1.0]
		seg01 = Segment.new(pos2, pos3)
		assert_equal(Vector3D[0.5, 0.5, 0.0], @t00.intersection(seg01, $tolerance))
		#
		pos2 = Vector3D[ 0.00, 0.00, 0.00]
		pos3 = Vector3D[ 1.00, 1.00, 1.00]
		seg01 = Segment.new(pos2, pos3)
		t = @t01.intersection(seg01, $tolerance)
		assert_in_delta(1.0/3.0, t[0], $tolerance)
		assert_in_delta(1.0/3.0, t[1], $tolerance)
		assert_in_delta(1.0/3.0, t[2], $tolerance)
		#
		pos2 = Vector3D[ 0.25, 0.25, 0.00]
		pos3 = Vector3D[ 0.25, 0.25, 1.00]
		seg01 = Segment.new(pos2, pos3)
		assert_equal(Vector3D[0.25, 0.25, 0.50], @t01.intersection(seg01, $tolerance))
	end

	#def test_intersect?
	#	TODO
	#end

	def test_parallel_segment?
		# 平行
		pos0 = Vector3D[0.0, 0.0, 2.0]
		pos1 = Vector3D[2.0, 0.0, 2.0]
		seg01 = Segment.new(pos0, pos1)
		assert_equal(true , @t00.parallel_segment?(seg01))

		# 面に含まれる
		pos0 = Vector3D[0.0, 0.0, 0.0]
		pos1 = Vector3D[2.0, 0.0, 0.0]
		seg01 = Segment.new(pos0, pos1)
		assert_equal(false, @t00.parallel_segment?(seg01))

		# 平行ではない。
		pos2 = Vector3D[0.0,10.0, 0.0]
		pos3 = Vector3D[0.0,10.0, 2.0]
		seg01 = Segment.new(pos0, pos1)
		assert_equal(false, @t00.parallel_segment?(seg01))
	end

	def test_normal_vector
		t = Vector3D[0.0, 0.0, 1.0]
		assert_equal(t, @t00.normal_vector)

		t = Vector3D[1.0, 1.0, 1.0]
		t = t * (1.0/t.r)
		assert_equal(t, @t01.normal_vector)

		t = Vector3D[0.0, 0.0, 1.0]
		assert_equal(t, @t02.normal_vector)
	end

	def test_equivalent?
		assert_raise(Triangle::TypeError){
			@t00.equivalent?([[ 0.0, 0.0, 0.0], [ 1.0, 0.0, 0.0], [ 0.0, 1.0, 0.0]])
		}

		t = Triangle.new([[ 0.0, 0.0, 0.0], [ 1.0, 0.0, 0.0], [ 0.0, 1.0, 0.0]])
		assert_equal(true , @t00.eql?(t))

		t = Triangle.new([[ 1.0, 0.0, 0.0], [ 0.0, 0.0, 0.0], [ 0.0, 1.0, 0.0]])
		assert_equal(true , @t00.eql?(t))

		t = Triangle.new([[ 1.0, 0.0, 0.0], [ 0.0, 1.0, 0.0], [ 0.0, 0.0, 0.0]])
		assert_equal(true , @t00.eql?(t))

		t = Triangle.new([[ 0.0, 0.0, 1.0], [ 1.0, 0.0, 0.0], [ 0.0, 1.0, 0.0]])
		assert_equal(false, @t00.eql?(t))

		# tolerance を設定の上 0.0
		t = Triangle.new([[ 0.0, 0.0, 1.0], [ 1.0, 0.0, 0.0], [ 0.0, 1.0, 0.0]])
		assert_equal(false, @t00.eql?(t, 0.0))

		# tolerance を 1.0 に設定
		t = Triangle.new([[ 0.0, 0.0, 1.0], [ 1.0, 0.0, 0.0], [ 0.0, 1.0, 0.0]])
		assert_equal(true, @t00.eql?(t, 1.0))
	end

	def test_equal2
		t = Triangle.new([[ 0.0, 0.0, 0.0], [ 1.0, 0.0, 0.0], [ 0.0, 1.0, 0.0]])
		assert_equal(true , @t00 == t)

		t = Triangle.new([[ 1.0, 0.0, 0.0], [ 0.0, 0.0, 0.0], [ 0.0, 1.0, 0.0]])
		assert_equal(false, @t00 == t)

		t = Triangle.new([[ 1.0, 0.0, 0.0], [ 0.0, 1.0, 0.0], [ 0.0, 0.0, 0.0]])
		assert_equal(false, @t00 == t)

		t = Triangle.new([[ 0.0, 0.0, 1.0], [ 1.0, 0.0, 0.0], [ 0.0, 1.0, 0.0]])
		assert_equal(false, @t00 == t)
	end

	def test_internal_axes
		@t01 = Triangle.new([[ 1.0, 0.0, 0.0], [ 0.0, 1.0, 0.0], [ 0.0, 0.0, 1.0]])
		@t02 = Triangle.new([[10.0,10.0,10.0], [20.0,10.0,10.0], [10.0,20.0,10.0]])

		t = Axes.new([[ 1.0, 0.0, 0.0], [ 0.0, 1.0, 0.0], [ 0.0, 0.0, 1.0]])
		assert_equal(t, @t00.internal_axes)

		t = @t01.internal_axes
		assert_in_delta(-1.0, t[0][0]              , $tolerance)
		assert_in_delta( 1.0, t[0][1]              , $tolerance)
		assert_in_delta( 0.0, t[0][2]              , $tolerance)
		assert_in_delta(-1.0, t[1][0]              , $tolerance)
		assert_in_delta( 0.0, t[1][1]              , $tolerance)
		assert_in_delta( 1.0, t[1][2]              , $tolerance)
		assert_in_delta(1.0/Math.sqrt(3.0), t[2][0], $tolerance)
		assert_in_delta(1.0/Math.sqrt(3.0), t[2][1], $tolerance)
		assert_in_delta(1.0/Math.sqrt(3.0), t[2][2], $tolerance)

		t = Axes.new([[ 10.0, 0.0, 0.0], [ 0.0, 10.0, 0.0], [ 0.0, 0.0, 1.0]])
		assert_equal(t, @t02.internal_axes)
	end

	def test_edges
		t = @t00.edges
		assert_equal(3, t.size)
		
		assert_equal(Segment.new(VEC_O, VEC_X), t[0])
		assert_equal(Segment.new(VEC_X, VEC_Y), t[1])
		assert_equal(Segment.new(VEC_Y, VEC_O), t[2])
	end

end

