#! /usr/bin/ruby

require "test/unit"
require "matrix"
require 'mageo.rb'
#require "mageo/vector3d.rb"
#require "mageo/vector3dinternal.rb"
#require "mageo/polar2d.rb"
#require "mageo/polar3d.rb"

class TC_Array < Test::Unit::TestCase
  $tolerance = 10.0**(-10)

  def setup
    @a = [1.0, 2.0, 3.0]
  end

  def test_to_v3d
    assert_equal( Mageo::Vector3D, @a.to_v3d.class )
    assert_in_delta( 1.0, @a.to_v3d[0], $tolerance )
    assert_in_delta( 2.0, @a.to_v3d[1], $tolerance )
    assert_in_delta( 3.0, @a.to_v3d[2], $tolerance )
    assert_raise( Mageo::Vector3D::RangeError ){ [1.0].to_v3d }
    assert_raise( Mageo::Vector3D::RangeError ){ [0.0, 1.0, 2.0, 3.0].to_v3d }
  end
end

class TC_Vector < Test::Unit::TestCase
  include Math

  $tolerance = 10.0**(-10)

  def setup
    @v0 = Vector[ 1.0, 2.0, 3.0 ]
    @v1 = Vector[ 1.0, 1.0 ]
    @v2 = Vector[ 1.0, 2.0, 3.0, 4.0 ]
  end

  def test_to_v3d
    assert_equal( Mageo::Vector3D, @v0.to_v3d.class )
    assert_in_delta( 1.0, @v0.to_v3d[0], $tolerance )
    assert_in_delta( 2.0, @v0.to_v3d[1], $tolerance )
    assert_in_delta( 3.0, @v0.to_v3d[2], $tolerance )
    assert_raise( Mageo::Vector3D::RangeError ){ Vector[1.0].to_v3d }
    assert_raise( Mageo::Vector3D::RangeError ){ Vector[0.0, 1.0, 2.0, 3.0].to_v3d }
  end
end

class TC_Vector3D < Test::Unit::TestCase
  $tolerance = 10.0**(-10)
  include Math

  def setup
    @v00 = Mageo::Vector3D[1.0, 0.0, 0.0]
    @v01 = Mageo::Vector3D[1.0, 0.0, 0.0]
    @v02 = Mageo::Vector3D[0.0, 1.0, 0.0]
    @v03 = Mageo::Vector3D[0.0, 0.0, 1.0]
    @v04 = Mageo::Vector3D[0.0, 0.0, 0.0]
    @v05 = Mageo::Vector3D[0.5, 0.5, 0.0]
    @v07 = Mageo::Vector3D[1.0, 2.0, 3.0]
    @v08 = Mageo::Vector3D[0.1, 0.2, 0.3]
  end

  def test_initialize
    assert_raise( Mageo::Vector3D::RangeError ){ Mageo::Vector3D[0.0, 0.0] }
    assert_raise( Mageo::Vector3D::RangeError ){ Mageo::Vector3D[0.0, 0.0, 0.0, 0.0] }

    assert_equal( Mageo::Vector3D, Mageo::Vector3D[0.0, 0.0, 1.0].class )
  end

  def test_add_and_delete
    #追加できないことを確認。
    assert_raise( NoMethodError ){ Mageo::Vector3D.push( 0.0 ) }
    assert_raise( NoMethodError ){ Mageo::Vector3D[3] = 0.0 }

    assert_raise( NoMethodError ){ Mageo::Vector3D.pop( 0.0 ) }
    assert_raise( NoMethodError ){ Mageo::Vector3D.delete[3] = 0.0 }
  end

  def test_access
    # read
    assert_equal(1.0, @v00[0])
    assert_equal(0.0, @v00[1])
    assert_equal(0.0, @v00[2])
    assert_raise(Mageo::Vector3D::RangeError){@v00[3]}
    assert_raise(Mageo::Vector3D::RangeError){@v00[-1]}

    # write
    @v00[0] = 2.0
    @v00[1] = 3.0
    @v00[2] = 4.0
    assert_equal(2.0, @v00[0])
    assert_equal(3.0, @v00[1])
    assert_equal(4.0, @v00[2])
    assert_raise(Mageo::Vector3D::RangeError){@v00[3]  = 0.0}
    assert_raise(Mageo::Vector3D::RangeError){@v00[-1] = 0.0}
  end

  def test_size
    assert_equal( 3, @v00.size )
  end

  def test_exterior_product
    #For class method
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.exterior_product( @v00, [1.0, 2.0, 3.0] )                 }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.exterior_product( @v00, Vector[1.0, 2.0, 3.0] )           }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.exterior_product( @v00, Mageo::Vector3DInternal[1.0, 2.0, 3.0] ) }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.exterior_product( [1.0, 2.0, 3.0]                , @v00 ) }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.exterior_product( Vector[1.0, 2.0, 3.0]          , @v00 ) }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.exterior_product( Mageo::Vector3DInternal[1.0, 2.0, 3.0], @v00 ) }

    assert_equal( Mageo::Vector3D, Mageo::Vector3D.exterior_product( @v00, @v01 ).class)
    assert_in_delta( 0.0, Mageo::Vector3D.exterior_product( @v00, @v01 )[0], $tolerance )
    assert_in_delta( 0.0, Mageo::Vector3D.exterior_product( @v00, @v01 )[1], $tolerance )
    assert_in_delta( 0.0, Mageo::Vector3D.exterior_product( @v00, @v01 )[2], $tolerance )
    assert_in_delta( 0.0, Mageo::Vector3D.exterior_product( @v00, @v02 )[0], $tolerance )
    assert_in_delta( 0.0, Mageo::Vector3D.exterior_product( @v00, @v02 )[1], $tolerance )
    assert_in_delta( 1.0, Mageo::Vector3D.exterior_product( @v00, @v02 )[2], $tolerance )
    assert_in_delta( 0.0, Mageo::Vector3D.exterior_product( @v00, @v03 )[0], $tolerance )
    assert_in_delta(-1.0, Mageo::Vector3D.exterior_product( @v00, @v03 )[1], $tolerance )
    assert_in_delta( 0.0, Mageo::Vector3D.exterior_product( @v00, @v03 )[2], $tolerance )
    assert_in_delta( 0.0, Mageo::Vector3D.exterior_product( @v00, @v04 )[0], $tolerance )
    assert_in_delta( 0.0, Mageo::Vector3D.exterior_product( @v00, @v04 )[1], $tolerance )
    assert_in_delta( 0.0, Mageo::Vector3D.exterior_product( @v00, @v04 )[2], $tolerance )
    assert_in_delta( 0.0, Mageo::Vector3D.exterior_product( @v00, @v05 )[0], $tolerance )
    assert_in_delta( 0.0, Mageo::Vector3D.exterior_product( @v00, @v05 )[1], $tolerance )
    assert_in_delta( 0.5, Mageo::Vector3D.exterior_product( @v00, @v05 )[2], $tolerance )

    assert_in_delta( 0.5, Mageo::Vector3D.cross_product( @v00, @v05 )[2], $tolerance )
    assert_in_delta( 0.5, Mageo::Vector3D.vector_product( @v00, @v05 )[2], $tolerance )

    #For instance method
    assert_raise( Mageo::Vector3D::TypeError ){ @v00.exterior_product( [1.0, 2.0, 3.0] )                 }
    assert_raise( Mageo::Vector3D::TypeError ){ @v00.exterior_product( Vector[1.0, 2.0, 3.0] )           }
    assert_raise( Mageo::Vector3D::TypeError ){ @v00.exterior_product( Mageo::Vector3DInternal[1.0, 2.0, 3.0] ) }

    assert_equal( 0.0, @v00.exterior_product( @v01 )[0], $tolerance )
    assert_equal( 0.0, @v00.exterior_product( @v01 )[1], $tolerance )
    assert_equal( 0.0, @v00.exterior_product( @v01 )[2], $tolerance )
    assert_equal( 0.0, @v00.exterior_product( @v02 )[0], $tolerance )
    assert_equal( 0.0, @v00.exterior_product( @v02 )[1], $tolerance )
    assert_equal( 1.0, @v00.exterior_product( @v02 )[2], $tolerance )
    assert_equal( 0.0, @v00.exterior_product( @v03 )[0], $tolerance )
    assert_equal(-1.0, @v00.exterior_product( @v03 )[1], $tolerance )
    assert_equal( 0.0, @v00.exterior_product( @v03 )[2], $tolerance )
    assert_equal( 0.0, @v00.exterior_product( @v04 )[0], $tolerance )
    assert_equal( 0.0, @v00.exterior_product( @v04 )[1], $tolerance )
    assert_equal( 0.0, @v00.exterior_product( @v04 )[2], $tolerance )
    assert_equal( 0.0, @v00.exterior_product( @v05 )[0], $tolerance )
    assert_equal( 0.0, @v00.exterior_product( @v05 )[1], $tolerance )
    assert_equal( 0.5, @v00.exterior_product( @v05 )[2], $tolerance )

    assert_equal( 0.5, @v00.cross_product( @v05 )[2], $tolerance )
    assert_equal( 0.5, @v00.vector_product( @v05 )[2], $tolerance )
  end

  def test_class
    assert_equal( Mageo::Vector3D, @v00.class )
    assert_equal( Mageo::Vector3D, ( @v00 - @v01 ).class )
    assert_equal( Mageo::Vector3D, ( @v00 * 3.0 ).class )
    assert_equal( Mageo::Vector3D, @v00.clone.class )
    assert_equal( Mageo::Vector3D, @v00.dup.class )

    #assert_equal( Mageo::Vector3D, @v00.collect{|x| x }.class )
    #assert_equal( Mageo::Vector3D, @v00.map{|x| x }.class )
    #assert_equal( Mageo::Vector3D, @v00.map2{|x| x }.class )
  end

  def test_equal_in_delta?
    assert_raise(Mageo::Vector3D::TypeError){@v00.equal_in_delta?( Vector[ 1.0, 0.0, 0.0 ])}
    assert_raise(Mageo::Vector3D::TypeError){@v00.equal_in_delta?( Mageo::Vector3DInternal[ 1.0, 0.0, 0.0 ])}
    assert_equal(true , @v00.equal_in_delta?( Mageo::Vector3D[ 1.0, 0.0, 0.0 ]))
    assert_equal(false, @v00.equal_in_delta?( Mageo::Vector3D[ 1.0, 0.0, 0.1 ]))
    assert_equal(true , @v00.equal_in_delta?( Mageo::Vector3D[ 1.0, 0.0, 0.1 ], 1.0))
  end

  def test_plus
    assert_raise( Mageo::Vector3D::TypeError ){ @v07 + [0.0, 1.0, 2.0] }
    assert_raise( Mageo::Vector3D::TypeError ){ @v07 + Vector[0.0, 1.0, 2.0] }
    assert_raise( Mageo::Vector3D::TypeError ){ @v07 + Mageo::Vector3DInternal[0.0, 1.0, 2.0] }

    assert_equal( Mageo::Vector3D, ( @v07 + @v08 ).class )
    t = @v07 + @v08
    assert_in_delta( 1.1, t[0], $tolerance )
    assert_in_delta( 2.2, t[1], $tolerance )
    assert_in_delta( 3.3, t[2], $tolerance )
  end

  def test_minus
    assert_raise( Mageo::Vector3D::TypeError ){ @v07 - [0.0, 1.0, 2.0] }
    assert_raise( Mageo::Vector3D::TypeError ){ @v07 - Vector[0.0, 1.0, 2.0] }
    assert_raise( Mageo::Vector3D::TypeError ){ @v07 - Mageo::Vector3DInternal[0.0, 1.0, 2.0] }

    assert_equal( Mageo::Vector3D, ( @v07 - @v08 ).class )
    t = @v07 - @v08
    assert_in_delta( 0.9, t[0], $tolerance )
    assert_in_delta( 1.8, t[1], $tolerance )
    assert_in_delta( 2.7, t[2], $tolerance )
  end

  def test_multiply
    assert_raise( Mageo::Vector3D::TypeError ){ @v07 * [0.0, 1.0, 2.0] }
    assert_raise( Mageo::Vector3D::TypeError ){ @v07 * Vector[0.0, 1.0, 2.0] }
    assert_raise( Mageo::Vector3D::TypeError ){ @v07 * Mageo::Vector3DInternal[0.0, 1.0, 2.0] }

    t = @v07 * 3
    assert_equal( Mageo::Vector3D, t.class )
    assert_in_delta( 3.0, t[0], $tolerance )
    assert_in_delta( 6.0, t[1], $tolerance )
    assert_in_delta( 9.0, t[2], $tolerance )

    t = @v07 * 3.0
    assert_equal( Mageo::Vector3D, t.class )
    assert_in_delta( 3.0, t[0], $tolerance )
    assert_in_delta( 6.0, t[1], $tolerance )
    assert_in_delta( 9.0, t[2], $tolerance )
  end

  def test_scalar_triple_product
    #For class method
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.scalar_triple_product( @v00, @v02, [1.0, 2.0, 3.0] )                 }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.scalar_triple_product( @v00, @v02, Vector[1.0, 2.0, 3.0] )           }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.scalar_triple_product( @v00, @v02, Mageo::Vector3DInternal[1.0, 2.0, 3.0] ) }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.scalar_triple_product( @v00, [1.0, 2.0, 3.0]                , @v02 ) }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.scalar_triple_product( @v00, Vector[1.0, 2.0, 3.0]          , @v02 ) }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.scalar_triple_product( @v00, Mageo::Vector3DInternal[1.0, 2.0, 3.0], @v02 ) }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.scalar_triple_product( [1.0, 2.0, 3.0]                , @v00, @v02 ) }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.scalar_triple_product( Vector[1.0, 2.0, 3.0]          , @v00, @v02 ) }
    assert_raise( Mageo::Vector3D::TypeError ){ Mageo::Vector3D.scalar_triple_product( Mageo::Vector3DInternal[1.0, 2.0, 3.0], @v00, @v02 ) }

    assert_in_delta( 0.0, Mageo::Vector3D.scalar_triple_product( @v00, @v01, @v02), $tolerance )
    assert_in_delta( 1.0, Mageo::Vector3D.scalar_triple_product( @v00, @v02, @v03), $tolerance )
    assert_in_delta(-1.0, Mageo::Vector3D.scalar_triple_product( @v00, @v03, @v02), $tolerance )
    assert_in_delta( 0.0, Mageo::Vector3D.scalar_triple_product( @v00, @v03, @v04), $tolerance )

    #For instance method
    assert_raise( Mageo::Vector3D::TypeError ){ @v00.scalar_triple_product( @v02, [1.0, 2.0, 3.0] )                 }
    assert_raise( Mageo::Vector3D::TypeError ){ @v00.scalar_triple_product( @v02, Vector[1.0, 2.0, 3.0] )           }
    assert_raise( Mageo::Vector3D::TypeError ){ @v00.scalar_triple_product( @v02, Mageo::Vector3DInternal[1.0, 2.0, 3.0] ) }
    assert_raise( Mageo::Vector3D::TypeError ){ @v00.scalar_triple_product( [1.0, 2.0, 3.0]                , @v02 ) }
    assert_raise( Mageo::Vector3D::TypeError ){ @v00.scalar_triple_product( Vector[1.0, 2.0, 3.0]          , @v02 ) }
    assert_raise( Mageo::Vector3D::TypeError ){ @v00.scalar_triple_product( Mageo::Vector3DInternal[1.0, 2.0, 3.0], @v02 ) }

    assert_in_delta( 0.0, @v00.scalar_triple_product( @v01, @v02), $tolerance )
    assert_in_delta( 1.0, @v00.scalar_triple_product( @v02, @v03), $tolerance )
    assert_in_delta(-1.0, @v00.scalar_triple_product( @v03, @v02), $tolerance )
    assert_in_delta( 0.0, @v00.scalar_triple_product( @v03, @v04), $tolerance )

    #どれかが Mageo::Vector3D 以外の、Vector クラスで3要素のものだった場合は例外。
  end

  def test_angle_radian
    #For class method
    assert_raise( Mageo::Vector3D::TypeError ) { Mageo::Vector3D.angle_radian( @v00, [1.0, 2.0, 3.0] )                 }
    assert_raise( Mageo::Vector3D::TypeError ) { Mageo::Vector3D.angle_radian( @v00, Vector[1.0, 2.0, 3.0] )           }
    assert_raise( Mageo::Vector3D::TypeError ) { Mageo::Vector3D.angle_radian( @v00, Mageo::Vector3DInternal[1.0, 2.0, 3.0] ) }
    assert_raise( Mageo::Vector3D::TypeError ) { Mageo::Vector3D.angle_radian( [1.0, 2.0, 3.0]                , @v00 ) }
    assert_raise( Mageo::Vector3D::TypeError ) { Mageo::Vector3D.angle_radian( Vector[1.0, 2.0, 3.0]          , @v00 ) }
    assert_raise( Mageo::Vector3D::TypeError ) { Mageo::Vector3D.angle_radian( Mageo::Vector3DInternal[1.0, 2.0, 3.0], @v00 ) }
    assert_raise( Mageo::Vector3D::ZeroOperation  ) { Mageo::Vector3D.angle_radian( @v00, @v04) }

    assert_in_delta( 0.0,          Mageo::Vector3D.angle_radian( @v00, @v01), $tolerance )
    assert_in_delta( PI/2.0,       Mageo::Vector3D.angle_radian( @v00, @v02), $tolerance )
    assert_in_delta( PI/2.0,       Mageo::Vector3D.angle_radian( @v00, @v03), $tolerance )
    assert_in_delta( PI/4.0,       Mageo::Vector3D.angle_radian( @v00, @v05), $tolerance )

    #For instance method
    assert_raise( Mageo::Vector3D::TypeError ) { @v00.angle_radian( [1.0, 2.0, 3.0] )                 }
    assert_raise( Mageo::Vector3D::TypeError ) { @v00.angle_radian( Vector[1.0, 2.0, 3.0] )           }
    assert_raise( Mageo::Vector3D::TypeError ) { @v00.angle_radian( Mageo::Vector3DInternal[1.0, 2.0, 3.0] ) }
    assert_raise( Mageo::Vector3D::ZeroOperation  ){ @v00.angle_radian( @v04) }
    assert_in_delta( 0.0,         @v00.angle_radian( @v01), $tolerance )
    assert_in_delta( PI/2.0,      @v00.angle_radian( @v02), $tolerance )
    assert_in_delta( PI/2.0,      @v00.angle_radian( @v03), $tolerance )
    assert_in_delta( PI/4.0,      @v00.angle_radian( @v05), $tolerance )

  end

  def test_angle_degree
    #For class method
    assert_raise( Mageo::Vector3D::TypeError ) { Mageo::Vector3D.angle_degree( @v00, [1.0, 2.0, 3.0] )                 }
    assert_raise( Mageo::Vector3D::TypeError ) { Mageo::Vector3D.angle_degree( @v00, Vector[1.0, 2.0, 3.0] )           }
    assert_raise( Mageo::Vector3D::TypeError ) { Mageo::Vector3D.angle_degree( @v00, Mageo::Vector3DInternal[1.0, 2.0, 3.0] ) }
    assert_raise( Mageo::Vector3D::TypeError ) { Mageo::Vector3D.angle_degree( [1.0, 2.0, 3.0]                 , @v00 ) }
    assert_raise( Mageo::Vector3D::TypeError ) { Mageo::Vector3D.angle_degree( Vector[1.0, 2.0, 3.0]           , @v00 ) }
    assert_raise( Mageo::Vector3D::TypeError ) { Mageo::Vector3D.angle_degree( Mageo::Vector3DInternal[1.0, 2.0, 3.0] , @v00 ) }
    assert_raise( Mageo::Vector3D::ZeroOperation  ) { Mageo::Vector3D.angle_degree( @v00, @v04) }
    assert_in_delta(  0.0,        Mageo::Vector3D.angle_degree( @v00, @v01), $tolerance )
    assert_in_delta( 90.0,        Mageo::Vector3D.angle_degree( @v00, @v02), $tolerance )
    assert_in_delta( 90.0,        Mageo::Vector3D.angle_degree( @v00, @v03), $tolerance )
    assert_in_delta( 45.0,        Mageo::Vector3D.angle_degree( @v00, @v05), $tolerance )

    #For instance method
    assert_raise( Mageo::Vector3D::TypeError ) { @v00.angle_degree( [1.0, 2.0, 3.0] )                 }
    assert_raise( Mageo::Vector3D::TypeError ) { @v00.angle_degree( Vector[1.0, 2.0, 3.0] )           }
    assert_raise( Mageo::Vector3D::TypeError ) { @v00.angle_degree( Mageo::Vector3DInternal[1.0, 2.0, 3.0] ) }
    assert_raise( Mageo::Vector3D::ZeroOperation  ){ @v00.angle_degree( @v04) }
    assert_in_delta(  0.0,        @v00.angle_degree( @v01), $tolerance )
    assert_in_delta( 90.0,        @v00.angle_degree( @v02), $tolerance )
    assert_in_delta( 90.0,        @v00.angle_degree( @v03), $tolerance )
    assert_in_delta( 45.0,        @v00.angle_degree( @v05), $tolerance )

    #どれかが Mageo::Vector3D 以外の、Vector クラスで3要素のものだった場合は例外。
  end

  def test_to_v3di
    array = [ [1.0, 1.0, 1.0], [0.0, 1.0, 1.0], [0.0, 0.0, 1.0] ]
    assert_raise(Mageo::Vector3D::TypeError){ Mageo::Vector3D[ 2.0, 5.0, 9.0 ].to_v3di(array) }

    axes = Mageo::Axes.new(array)
    t = Mageo::Vector3D[ 2.0, 5.0, 9.0 ].to_v3di( axes )
    assert_equal( Mageo::Vector3DInternal, t.class )
    assert_in_delta( 2.0, t[0], $tolerance )
    assert_in_delta( 3.0, t[1], $tolerance )
    assert_in_delta( 4.0, t[2], $tolerance )
  end

  def test_to_p3d
    vA = Mageo::Vector3D[ 2.0, 2.0, 2.0]
    vB = Mageo::Vector3D[ 0.0, 2.0, 2.0]
    vC = Mageo::Vector3D[ 0.0, 0.0, 2.0]
    vD = Mageo::Vector3D[-2.0,-2.0,-2.0]
    vE = Mageo::Vector3D[ 0.0,-2.0,-2.0]
    vF = Mageo::Vector3D[ 0.0, 0.0,-2.0]

    assert_in_delta( 2.0*sqrt(3.0)       , vA.to_p3d.r    , $tolerance )
    assert_in_delta( acos( sqrt(1/3.0) ) , vA.to_p3d.theta, $tolerance )
    assert_in_delta( 0.25*PI             , vA.to_p3d.phi  , $tolerance )
    assert_in_delta( 2.0*sqrt(2.0)       , vB.to_p3d.r    , $tolerance )
    assert_in_delta( 0.25*PI             , vB.to_p3d.theta, $tolerance )
    assert_in_delta( 0.50*PI             , vB.to_p3d.phi  , $tolerance )
    assert_in_delta( 2.0                 , vC.to_p3d.r    , $tolerance )
    assert_in_delta( 0.00*PI             , vC.to_p3d.theta, $tolerance )
    assert_in_delta( 0.00*PI             , vC.to_p3d.phi  , $tolerance )

    assert_in_delta( 2.0*sqrt(3.0)       , vD.to_p3d.r    , $tolerance )
    assert_in_delta( 2.0*sqrt(2.0)       , vE.to_p3d.r    , $tolerance )
    assert_in_delta( 2.0                 , vF.to_p3d.r    , $tolerance )

    assert_in_delta( acos(-sqrt(1/3.0) ) , vD.to_p3d.theta, $tolerance )
    assert_in_delta( 0.75*PI             , vE.to_p3d.theta, $tolerance )
    assert_in_delta( 1.00*PI             , vF.to_p3d.theta, $tolerance )

    assert_in_delta( 1.25*PI             , vD.to_p3d.phi  , $tolerance )
    assert_in_delta( 1.50*PI             , vE.to_p3d.phi  , $tolerance )
    assert_in_delta( 0.00*PI             , vF.to_p3d.phi  , $tolerance )
  end

  def test_rotate_axis!
    vA = Mageo::Vector3D[ 2.0, 2.0, 2.0 ]
    assert_raise( Mageo::Vector3D::RangeError ){ vA.rotate_axis!( -1, 0.25*PI ) }
    assert_raise( Mageo::Vector3D::RangeError ){ vA.rotate_axis!(  3, 0.25*PI ) }

    r8 = sqrt(8.0)
    vA = Mageo::Vector3D[ 2.0, 2.0, 2.0 ]

    vA.rotate_axis!( 0, 0.25*PI )
    assert_equal( Mageo::Vector3D  , vA.class )

    vA = Mageo::Vector3D[ 2.0, 2.0, 2.0 ]
    vA.rotate_axis!( 0, 0.25*PI )
    assert_in_delta( 2.0, vA[0], $tolerance )
    assert_in_delta( 0.0, vA[1], $tolerance )
    assert_in_delta( r8 , vA[2], $tolerance )

    vA = Mageo::Vector3D[ 2.0, 2.0, 2.0 ]
    vA.rotate_axis!( 1, 0.25*PI )
    assert_in_delta( r8 , vA[0], $tolerance )
    assert_in_delta( 2.0, vA[1], $tolerance )
    assert_in_delta( 0.0, vA[2], $tolerance )

    vA = Mageo::Vector3D[ 2.0, 2.0, 2.0 ]
    vA.rotate_axis!( 2, 0.25*PI )
    assert_in_delta( 0.0, vA[0], $tolerance )
    assert_in_delta( r8 , vA[1], $tolerance )
    assert_in_delta( 2.0, vA[2], $tolerance )

    vA = Mageo::Vector3D[ 2.0, 2.0, 2.0 ]
    vA.rotate_axis!( 0, -0.25*PI )
    assert_in_delta( 2.0, vA[0], $tolerance )
    assert_in_delta( r8 , vA[1], $tolerance )
    assert_in_delta( 0.0, vA[2], $tolerance )

    vA = Mageo::Vector3D[ 2.0, 2.0, 2.0 ]
    vA.rotate_axis!( 1, -0.25*PI )
    assert_in_delta( 0.0, vA[0], $tolerance )
    assert_in_delta( 2.0, vA[1], $tolerance )
    assert_in_delta( r8 , vA[2], $tolerance )

    vA = Mageo::Vector3D[ 2.0, 2.0, 2.0 ]
    vA.rotate_axis!( 2, -0.25*PI )
    assert_in_delta( r8 , vA[0], $tolerance )
    assert_in_delta( 0.0, vA[1], $tolerance )
    assert_in_delta( 2.0, vA[2], $tolerance )
  end

  def test_rotate_axis
    vA = Mageo::Vector3D[ 2.0, 2.0, 2.0 ]
    assert_raise( Mageo::Vector3D::RangeError ){ vA.rotate_axis( -1, 0.25*PI ) }
    assert_raise( Mageo::Vector3D::RangeError ){ vA.rotate_axis(  3, 0.25*PI ) }

    r8 = sqrt(8.0)
    assert_equal( Mageo::Vector3D                 , vA.rotate_axis( 0, 0.25*PI ).class )
    assert_equal( Mageo::Vector3D                 , vA.rotate_axis( 1, 0.25*PI ).class )
    assert_equal( Mageo::Vector3D                 , vA.rotate_axis( 2, 0.25*PI ).class )

    assert_in_delta( 2.0, vA.rotate_axis( 0, 0.25*PI )[0], $tolerance )
    assert_in_delta( 0.0, vA.rotate_axis( 0, 0.25*PI )[1], $tolerance )
    assert_in_delta( r8 , vA.rotate_axis( 0, 0.25*PI )[2], $tolerance )
    assert_in_delta( r8 , vA.rotate_axis( 1, 0.25*PI )[0], $tolerance )
    assert_in_delta( 2.0, vA.rotate_axis( 1, 0.25*PI )[1], $tolerance )
    assert_in_delta( 0.0, vA.rotate_axis( 1, 0.25*PI )[2], $tolerance )
    assert_in_delta( 0.0, vA.rotate_axis( 2, 0.25*PI )[0], $tolerance )
    assert_in_delta( r8 , vA.rotate_axis( 2, 0.25*PI )[1], $tolerance )
    assert_in_delta( 2.0, vA.rotate_axis( 2, 0.25*PI )[2], $tolerance )

    assert_in_delta( 2.0, vA.rotate_axis( 0, -0.25*PI )[0], $tolerance )
    assert_in_delta( r8 , vA.rotate_axis( 0, -0.25*PI )[1], $tolerance )
    assert_in_delta( 0.0, vA.rotate_axis( 0, -0.25*PI )[2], $tolerance )
    assert_in_delta( 0.0, vA.rotate_axis( 1, -0.25*PI )[0], $tolerance )
    assert_in_delta( 2.0, vA.rotate_axis( 1, -0.25*PI )[1], $tolerance )
    assert_in_delta( r8 , vA.rotate_axis( 1, -0.25*PI )[2], $tolerance )
    assert_in_delta( r8 , vA.rotate_axis( 2, -0.25*PI )[0], $tolerance )
    assert_in_delta( 0.0, vA.rotate_axis( 2, -0.25*PI )[1], $tolerance )
    assert_in_delta( 2.0, vA.rotate_axis( 2, -0.25*PI )[2], $tolerance )
  end
end

