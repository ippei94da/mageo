#! /usr/bin/env ruby
# coding: utf-8

# n 次元空間における座標系を表現する n 本のベクトルを扱うクラス。
class Mageo::Axes
  attr_reader :axes

  class InitializeError < Exception; end


  # 要素数が nxn でなければ例外。0x0 も例外。
  # 角各要素は to_f メソッドを持たなければならない。
  def initialize(vectors)
    raise InitializeError if vectors.size == 0
    @axes = vectors.map{|vector| Vector[*vector]}

    #raise InitializeError unless @axes.regular? # この判定はうまくいかない。バグ？
    @axes.each do |vector|
      raise InitializeError unless @axes.size == vector.size
    end
  end

  def self.independent?(axes)
    return Matrix[* axes.map{|i| i.to_a}].regular?
  end

  # Return true is the vector is not independent.
  def self.dependent?(axes)
    return ! (self.independent?(axes))
  end

  # Return a number of vectors in axes, always three.
  # Mimic for Array.
  def size
    return @axes.size
  end

  # Check equal.
  # Usually, this method should not be used, except for tests.
  def ==(other)
    result = true
    size.times do |i|
      size.times do |j|
        result = false if @axes[i][j] != other.axes[i][j]
      end
    end

    return result
  end

  def dependent?
    self.class.dependent?(@axes)
  end

  def independent?
    self.class.independent?(@axes)
  end

  def to_a
    result = [
      @axes[0].to_a,
      @axes[1].to_a,
      @axes[2].to_a,
    ]
    return result
  end

  # Item access for three axes in cartesian coordinates.
  # Note: []= method is not provided.
  def [](index)
    @axes[ index ]
  end

  # Iterate each vector of axes.
  def each
    @axes.each { |i| yield(i) }
  end

  # Convert to Array. Non-destructive.
  def to_a
    return @axes.map { |vector| vector.to_a }
  end
end

