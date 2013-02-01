#! /usr/bin/env ruby
# coding: utf-8

require 'matrix'


class Vector
  include Math

  #Polar2D クラスインスタンスへの変換。
  def to_p2d
    raise Vector::SizeError if self.size != 2
    x, y = *self
    r = Math::sqrt( x**2 + y**2 )

    theta = 0.0
    #ゼロ割り対策
    if ( ( x == 0 ) && ( y == 0 ) )
      theta = 0.0 * PI
    elsif ( ( x == 0 ) && ( y > 0 ) )
      theta = 0.5 * PI
    elsif ( ( x == 0 ) && ( y < 0 ) )
      theta = -0.5 * PI
    elsif ( ( x > 0 ) && ( y == 0 ) )
      theta = 0.0 * PI
    elsif ( ( x < 0 ) && ( y == 0 ) )
      theta = 1.0 * PI
    else
      theta = Math::atan( y/x )
      theta += PI if ( x < 0) 
    end
    Polar2D.new( r, theta ).minimize_theta
  end
end

#2次元極座標。
#極座標ライブラリでは、角度は基本的に radian を使用する。
#degree は人間の都合で決められた尺度だろう。
#まあ人間用に degree 用インターフェイスも用意することもあるかもしれんが。
class Polar2D

  include Math

  ##クラスメソッド

  #与えられた角度 radian を 0 <= radian < 2*PI の間の角度に変換する破壊破壊的メソッド。
  def Polar2D.minimum_radian( radian )
    tmp = ( radian / (2.0*PI) )
    tmp = tmp - tmp.floor
    (2.0*PI) * tmp
  end


  ##インスタンスメソッド

  attr_reader :r, :theta

  #
  def initialize( r, theta)
    @r = r
    @theta = theta
  end

  #2次元 Vector に変換。
  def to_v
    Vector[ @r * cos( @theta ), @r * sin( @theta ) ]
  end

  #極座標を回転させる破壊的メソッド。
  #radian は左回りを正方向とした角度(ラジアン)。
  def rotate!( radian )
    @theta += radian
  end

  #極座標を回転させたオブジェクトを返す非破壊破壊的メソッド。
  #theta は左回りを正方向とした角度。
  def rotate( radian )
    result = Marshal.load( Marshal.dump( self ) )
    result.rotate!( radian )
    result
  end

  #theta を 0 <= theta < 2*PI の間の角度に変換する破壊破壊的メソッド。
  def minimize_theta!
    @theta = Polar2D.minimum_radian( @theta )
  end

  #theta を 0 <= theta < 2*PI の間の角度に変換したオブジェクトを返す非破壊破壊的メソッド。
  def minimize_theta
    result = Marshal.load( Marshal.dump( self ) )
    result.minimize_theta!
    result
  end

end
