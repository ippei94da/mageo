#! /usr/bin/env ruby
# coding: utf-8

require "rubygems"
gem     "builtinextension"
require "array/includeeql.rb"

# This class is obsoleted.
#
# 多面体を表現する抽象クラス。
# 面は必ず三角形で、たとえば四角形も2つの三角形であると考える。
# initialize メソッドは subclass で再定義する。
# subclass の注意点。
#   - 凸包であることを前提とする。
#     チェック機構は Mageo::Polyhedron クラスで持っているべきだが、面倒なので後回し。
#     3次元凸包判定の方法をぐぐったが、これといったものが見つからない。
#   - 定義された面同士の間に隙間がないことを前提とする。
#     チェック機構は Mageo::Polyhedron クラスで持っているべきだが、面倒なので後回し。
#   - 頂点リスト @vertices と、面リスト @vertex_indices_of_triangles を持つ。
#     ただし、@vertex_indices_of_triangles は Mageo::Triangle クラスインスタンスではなく、
#     @vertices 内の index。
#     see Mageo::Tetrahedron.rb
#   - メインのテストは 四面体 Mageo::Tetrahedron クラスで行っている。
class Mageo::Polyhedron
#  attr_reader :vertices
#
#  class TypeError < StandardError; end
#  class NotImplementError < StandardError; end
#
#  # initialize で例外を返すことでインスタンスを生成できない抽象クラスを表現。
#  # subclass で再定義する。
#  def initialize()
#    raise NotImplementedError, "need to define `initialize'"
#  end
#
#  def edges
#    results = []
#    triangles.each do |triangle|
#      triangle.edges.each do |edge|
#        results << edge unless results.include_eql?(edge)
#      end
#    end
#    return results
#  end
#
#  def triangles
#    results = Mageo::Tetrahedron::VERTEX_INDICES_OF_TRIANGLES.map do |indices|
#      Mageo::Triangle.new( *(indices.map{|i| @vertices[i] }) )
#    end
#    return results
#  end
#
#  #面で囲まれた空間の中にあれば true を返す。
#  def inside?( pos )
#    raise TypeError if pos.class == Mageo::Vector3DInternal
#
#    result = true
#    triangles.each do |triangle|
#      result = false unless triangle.same_side?( center, pos.to_v3d )
#    end
#    return result
#  end
#
#  def include?(pos, tolerance = 0.0)
#    raise TypeError if pos.class == Mageo::Vector3DInternal
#
#    return true if inside?( pos )
#    triangles.each do |triangle|
#      #pp pos
#      #pp triangle
#      return true if triangle.include?(pos.to_v3d, tolerance)
#    end
#    return false
#  end
#
#  #各頂点の座標の平均値を返す。
#  def center
#    tmp = Mageo::Vector3D[ 0.0, 0.0, 0.0 ]
#    @vertices.each do |vertex|
#      tmp += vertex
#    end
#    return tmp * ( 1.0 / @vertices.size.to_f ) # 座標の平均の算出
#  end
#
#  def translate!(vector)
#    @vertices.map! do |pos|
#      pos + vector
#    end
#  end
#
#  def translate(vector)
#    result = Marshal.load(Marshal.dump(self))
#    result.translate! vector
#    result
#  end
#
#  def shared_vertices(other, tolerance = 0.0)
#    results = []
#    @vertices.each do |sv|
#      flag = false
#      other.vertices.each do |ov|
#        flag = true if (ov - sv).r <= tolerance
#      end
#      results << sv if flag
#    end
#    results
#  end
#
#  #private
#
#  #def vertices_include?(vertex, vertices, tolerance)
#  #end
#
end

