#! /usr/bin/env ruby
# coding: utf-8

## 3次元空間中の八面体を表現するクラス
#class Mageo::Octahedron < Mageo::Polyhedron
#
#  class InitializeError < Exception; end
#
#  #八面体は 6個の頂点で構成されるが、これを3組の対体角で指定する。
#  #e.g., 
#  #  [
#  #    [ [ -1,  0,  0 ], [  1,  0,  0 ] ],
#  #    [ [  0, -1,  0 ], [  0,  1,  0 ] ],
#  #    [ [  0,  0, -1 ], [  0,  0,  1 ] ],
#  #  ]
#  #
#  #凸包であることのチェックは難しいのでしない。
#  #TODO: 頂点が重複している、面上にあるなどのチェックも本来はすべきだが、入れていない。
#  def initialize( pairs )
#    raise InitializeError if pairs.class != Array
#    raise InitializeError if pairs.size != 3
#    pairs.each do |pair|
#      raise InitializeError unless pair.class == Array
#      raise InitializeError if pair.size != 2
#      pair.each do |pos|
#        raise InitializeError if pos.size != 3
#        raise InitializeError unless pos.methods.include?( :[] )
#        raise InitializeError unless pos.methods.include?( :map )
#      end
#    end
#
#    pairs.flatten.each do |vertex|
#      raise InitializeError if vertex.class == Mageo::Vector3DInternal
#    end
#
#
#    @vertices = []
#    pairs.each do |pair|
#      pair.each do |vertex|
#        @vertices << vertex.to_v3d
#      end
#    end
#
#    @vertex_indices_of_triangles = [
#      [ 0, 2, 4],
#      [ 0, 2, 5],
#      [ 0, 3, 4],
#      [ 0, 3, 5],
#      [ 1, 2, 4],
#      [ 1, 2, 5],
#      [ 1, 3, 4],
#      [ 1, 3, 5]
#    ]
#  end
#end
