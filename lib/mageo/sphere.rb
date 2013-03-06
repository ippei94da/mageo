#! /usr/bin/env ruby
# coding: utf-8

#require "mageo.rb"
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

