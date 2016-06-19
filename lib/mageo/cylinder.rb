#! /usr/bin/env ruby
# coding: utf-8

#
# Class for cylinder
#
class Mageo::Cylinder
  attr_reader :positions, :radius

  # 座標と半径
  # positions は 両底面の中心座標を入れた配列。
  def initialize(position0, position1, radius)
    @positions = [
      Mageo::Vector3D[*position0],
      Mageo::Vector3D[*position1]
    ]
    @radius = radius
  end
end

