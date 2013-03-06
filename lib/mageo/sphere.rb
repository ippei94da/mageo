#! /usr/bin/env ruby
# coding: utf-8

# 球を表現するクラス。
#
class Mageo::Sphere
  attr_reader :position, :radius

  # 座標と半径
  def initialize(position, radius)
    @position = Mageo::Vector3D[*position]
    @radius = radius
  end
end

