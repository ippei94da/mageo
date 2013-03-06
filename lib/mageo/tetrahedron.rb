#! /usr/bin/env ruby
# coding: utf-8

<<<<<<< HEAD
#require "mageo.rb"
=======
require "mageo.rb"
>>>>>>> 234bd769f956578c1d010c9f440f20bd470e8b97
#require "mageo/vector3d.rb"
#require "mageo/triangle.rb"
#require "mageo/polyhedron.rb"


#
# 直交座標系 3次元空間内の四面体を表現するクラス。
#
class Tetrahedron < Mageo::Polyhedron

  class InitializeError < Exception; end

  # vertices には四面体の頂点を順不同で入れた Array。
  def initialize( vertices )
    raise InitializeError if vertices.class != Array
    raise InitializeError if vertices.size != 4
    vertices.each do |vertex|
      raise InitializeError if vertex.size != 3
      raise InitializeError unless vertex.methods.include?( :[] )
      raise InitializeError unless vertex.methods.include?( :map )
    end
    vertices.each do |vertex|
      raise InitializeError if vertex.class == Vector3DInternal
    end

    @vertices = vertices.map { |vertex| vertex.to_v3d }

    @vertex_indices_of_triangles = [
      [ 0, 1, 2 ], 
      [ 1, 2, 3 ],
      [ 2, 3, 0 ], 
      [ 3, 0, 1 ],
    ]

    raise InitializeError, "volume is zero." if volume == 0.0
  end
end

