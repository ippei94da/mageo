#! /usr/bin/env ruby
# coding: utf-8

# 線分を表すクラス。
class Mageo::Segment
  attr_reader :endpoints

  class InitializeError < Exception; end
  class TypeError < Exception; end

  
  # 端点を2つ渡す。
  def initialize(vector0, vector1)
    raise InitializeError if vector0.class != Vector3D
    raise InitializeError if vector1.class != Vector3D
    raise InitializeError if vector0 == vector1
    
    @endpoints = [vector0, vector1]
  end

  # position で与えられた点が線分の中にある点か？
  # tolerance = 0.0 では計算誤差のためにほとんど真とならない。
  # position は Vector3D クラスインスタンスでなければならない。
  def include?(position, tolerance)
    raise TypeError if position.class != Vector3D

    vec_self = @endpoints[1] - @endpoints[0]
    vec_other = position - @endpoints[0]

    # 両端の点は計算誤差で失敗しやすいので true にしておく。
    return true if position == @endpoints[0]
    return true if position == @endpoints[1]

    # 長さ方向チェック
    inner_product = vec_self.inner_product(vec_other)
    return false if (inner_product < 0.0 )
    return false if ( vec_self.r ** 2 < inner_product)

    # 垂直方向チェック
    vec_outer = vec_other - vec_self * (inner_product / (vec_self.r)**2)
    return false if tolerance < vec_outer.r

    # ここまでチェックを通過すれば true
    return true

    ##ex_product = vec_self.exterior_product(vec_other)
    #あかんな。
    #normalize して、
    #この方向の成分を出さんと。
    #外積もおかしい。

    #return false if ( ex_product[2].abs > tolerance )

  end

  # endpoints で取り出せる座標2つのうち、最初のものから最後のものへのベクトルを表す
  # Vector3D クラスインスタンスを返す。
  def to_v3d
    return @endpoints[1] - @endpoints[0]
  end

  # 等価チェック。
  # uniq できるようにするため。
  def eql?(other)
    raise TypeError if other.class != Mageo::Segment
    @endpoints.each do |point|
      return false unless other.endpoints.include?(point)
    end
    return true
  end

  def ==(other)
    raise TypeError if other.class != Mageo::Segment
    @endpoints.size.times do |i|
      return false unless other.endpoints[i] == @endpoints[i]
    end
    return true
  end
end

