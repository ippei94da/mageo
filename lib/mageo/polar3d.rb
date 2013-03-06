#! /usr/bin/env ruby
# coding: utf-8

#3次元極座標。
#極座標ライブラリでは、角度は基本的に radian を使用する。
#degree は人間の都合で決められた尺度だろう。
#まあ人間用に degree 用インターフェイスも用意することもあるかもしれんが。
class Mageo::Polar3D

  include Math
  
  attr_reader :r, :theta, :phi

  #
  def initialize( r, theta, phi)
    @r = r
    @theta = theta
    @phi = phi
  end

  #3次元 Vector に変換。
  def to_v3d
    #Vector[ @r * cos( @theta ), @r * sin( @theta ) ]
    x = @r * sin( @theta ) * cos( @phi )
    y = @r * sin( @theta ) * sin( @phi )
    z = @r * cos( @theta )
    Mageo::Vector3D[ x, y, z ]
  end

  #phi を 0 <= phi < 2*PI の間の角度に変換する破壊破壊的メソッド。
  def minimize_phi!
    tmp = ( @phi / (2.0*PI) )
    tmp = tmp - tmp.floor
    @phi = (2.0*PI) * tmp
  end

  #phi を 0 <= phi < 2*PI の間の角度に変換したオブジェクトを返す非破壊破壊的メソッド。
  def minimize_phi
    result = Marshal.load( Marshal.dump( self ) )
    result.minimize_phi!
    result
  end
end
