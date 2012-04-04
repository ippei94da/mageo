#! /usr/bin/ruby

require "test/unit"
require "matrix"
require "mageo/vector.rb"
require "mageo/vector3d.rb"

class TC_Vector < Test::Unit::TestCase
	#include Math
	$tolerance = 1.0E-10

	def setup
		@v0 = Vector[ 1.0, 2.0, 3.0 ]
		@v1 = Vector[ 1.0, 1.0 ]
		@v2 = Vector[ 1.0, 2.0, 3.0, 4.0 ]
	end

	def test_equal
		assert_equal(false, @v0 == Vector[1.0, 2.0, 4.0] )
		assert_equal(true,  @v0 == Vector[1.0, 2.0, 3.0] )
	end

	def test_unit_vector
		assert_raise( Vector::ZeroOperation ){ Vector[0.0, 0.0, 0.0].unit_vector }

		assert_in_delta( 1.0/Math::sqrt(14.0), @v0.unit_vector[0], $tolerance )
		assert_in_delta( 2.0/Math::sqrt(14.0), @v0.unit_vector[1], $tolerance )
		assert_in_delta( 3.0/Math::sqrt(14.0), @v0.unit_vector[2], $tolerance )
		assert_equal( Vector[1.0, 2.0, 3.0], @v0) #非破壊であることを確認。
	end

	def test_floor
		tmp = @v0.floor
		assert_equal(Vector, tmp.class)
		assert_equal(1, tmp[0])
		assert_equal(2, tmp[1])
		assert_equal(3, tmp[2])
		assert_equal(3, tmp.size)

		tmp = @v1.floor
		assert_equal(1, tmp[0])
		assert_equal(1, tmp[1])
		assert_equal(2, tmp.size)
		
		tmp = Vector[ 1.1, 2.2].floor
		assert_equal(1, tmp[0])
		assert_equal(2, tmp[1])
		assert_equal(2, tmp.size)
		
		tmp = Vector[-1.1,-2.2].floor
		assert_equal(-2, tmp[0])
		assert_equal(-3, tmp[1])
		assert_equal(2, tmp.size)

		# positive decimal like
		vec = Vector[-1.1,-2.2]
		tmp = vec - vec.floor
		assert_in_delta(0.9, tmp[0], $tolerance)
		assert_in_delta(0.8, tmp[1], $tolerance)
		assert_equal(2, tmp.size)

		# inherited class
		tmp = Vector3D[1.1, 2.2, 3.3].floor
		assert_equal(Vector3D, tmp.class)
		assert_equal(1, tmp[0])
		assert_equal(2, tmp[1])
		assert_equal(3, tmp[2])
		assert_equal(3, tmp.size)

	end

end

