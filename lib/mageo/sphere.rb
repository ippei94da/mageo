#! /usr/bin/env ruby
# coding: utf-8

<<<<<<< HEAD
#require "mageo.rb"
=======
require "mageo.rb"
>>>>>>> 234bd769f956578c1d010c9f440f20bd470e8b97
#require "mageo/vector3d.rb"

#
# 球を表現するクラス。
#
class Mageo::Sphere
  attr_reader :position, :radius

  # 座標と半径
  def initialize(position, radius)
    @position = Vector3D[*position]
    @radius = radius
  end
end

