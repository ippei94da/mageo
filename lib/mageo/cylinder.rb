#! /usr/bin/env ruby
# coding: utf-8

#require "mageo/vector3d.rb"
<<<<<<< HEAD
#require "mageo.rb"
=======
require "mageo.rb"
>>>>>>> 234bd769f956578c1d010c9f440f20bd470e8b97

#
# 球を表現するクラス。
#
class Mageo::Cylinder
  attr_reader :positions, :radius

  # 座標と半径
  # positions は 両底面の中心座標を入れた配列。
  def initialize(position, radius)
    @positions = [
      Vector3D[*position[0]],
      Vector3D[*position[1]]
    ]
    @radius = radius
  end
end

