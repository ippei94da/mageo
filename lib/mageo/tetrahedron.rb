#! /usr/bin/env ruby
# coding: utf-8

#
# 直交座標系 3次元空間内の四面体を表現するクラス。
#
#class Mageo::Tetrahedron < Mageo::Polyhedron
class Mageo::Tetrahedron

  class InitializeError < Exception; end

  VERTEX_INDICES_OF_TRIANGLES = [ [ 0, 1, 2 ], [ 1, 2, 3 ], [ 2, 3, 0 ], [ 3, 0, 1 ] ]

  attr_reader :vertices

  class TypeError < StandardError; end
  class NotImplementError < StandardError; end

  def edges
    results = []
    triangles.each do |triangle|
      triangle.edges.each do |edge|
        results << edge unless results.include_eql?(edge)
      end
    end
    return results
  end

  def triangles
    results = Mageo::Tetrahedron::VERTEX_INDICES_OF_TRIANGLES.map do |indices|
      Mageo::Triangle.new( *(indices.map{|i| @vertices[i] }) )
    end
    return results
  end

  #面で囲まれた空間の中にあれば true を返す。
  def inside?( pos )
    raise TypeError if pos.class == Mageo::Vector3DInternal

    result = true
    triangles.each do |triangle|
      result = false unless triangle.same_side?( center, pos.to_v3d )
    end
    return result
  end

  def include?(pos, tolerance = 0.0)
    raise TypeError if pos.class == Mageo::Vector3DInternal

    return true if inside?( pos )
    triangles.each do |triangle|
      #pp pos
      #pp triangle
      return true if triangle.include?(pos.to_v3d, tolerance)
    end
    return false
  end

  #各頂点の座標の平均値を返す。
  def center
    tmp = Mageo::Vector3D[ 0.0, 0.0, 0.0 ]
    @vertices.each do |vertex|
      tmp += vertex
    end
    return tmp * ( 1.0 / @vertices.size.to_f ) # 座標の平均の算出
  end

  def translate!(vector)
    @vertices.map! do |pos|
      pos + vector
    end
  end

  def translate(vector)
    result = Marshal.load(Marshal.dump(self))
    result.translate! vector
    result
  end

  def shared_vertices(other, tolerance = 0.0)
    results = []
    @vertices.each do |sv|
      flag = false
      other.vertices.each do |ov|
        flag = true if (ov - sv).r <= tolerance
      end
      results << sv if flag
    end
    results
  end

  #private

  #def vertices_include?(vertex, vertices, tolerance)
  #end


  # vertices には四面体の頂点を順不同で入れた Array。
  def initialize( v0, v1, v2, v3 )
    #raise InitializeError if vertices.class != Array
    #raise InitializeError if vertices.size != 4
    #vertices.each do |vertex|
    #  raise InitializeError if vertex.size != 3
    #  raise InitializeError unless vertex.methods.include?( :[] )
    #  raise InitializeError unless vertex.methods.include?( :map )
    #end
    #@vertices = vertices.map { |vertex| vertex.to_v3d }
    vertices = [v0, v1, v2, v3]
    vertices.each do |vertex|
      raise InitializeError if vertex.class == Mageo::Vector3DInternal
    end

    @vertices = vertices.map {|v| v.to_v3d}

    raise InitializeError, "volume is zero." if volume == 0.0
  end

  # 体積を返す
  def volume
    result = 0.0
    [ [ 0, 1, 2 ], [ 1, 2, 3 ], [ 2, 3, 0 ], [ 3, 0, 1 ] ].each do |tri_vertices|
      vectors =  tri_vertices.map { |i| @vertices[i] - center }
      volume = Mageo::Vector3D.scalar_triple_product( *vectors ).abs
      volume /= 6.0
      result += volume
    end
    return result
  end

end

