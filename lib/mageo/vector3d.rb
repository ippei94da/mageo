#! /usr/bin/ruby

require "rubygems"
gem "malge"
require "malge.rb"
#require "malge/simultaneousequations.rb"
#require "simultaneousequations.rb"

# Open class to add "to_v3d" method.
class Array
  # Convert Array to Mageo::Vector3D
  def to_v3d
    Mageo::Vector3D[*self]
    #要素数チェックは Mageo::Vector3D.[] 側でやっている。
  end
end

class Vector
  # Return a new instance converted to Mageo::Vector3D class.
  def to_v3d
    Mageo::Vector3D[*self]
    #要素数チェックは Mageo::Vector3D.[] 側でやっている。
  end
end


# Vector class specialized for vectors in a three-dimensional Cartesian space.
# This class provide exterior_product method and others, which is not included
# in native Vector class.
# This class is constructed under the assumption in the Cartesian coordinate.
# If you want to be in an internal coordinate, you can use Math/Mageo::Vector3DInternal.rb .
# 
# Memo:
#   Mageo::Vector3DInternal との対比として、Vector3DCartesian という名前にすることも考えたが、
#   長くなるし、普通直交座標で考えるよね、と。
# 
#   インスタンス生成の時点で要素数をチェックし、要素の追加削除を禁止しているので
#   要素数は常に3であることが保証されている。
# 
class Mageo::Vector3D < Vector

  class TypeError < Exception; end
  class ZeroOperation < Exception; end
  class RangeError < Exception; end

  # Class methods

  def self.[](*args)
    raise RangeError, "#{args}" unless args.size == 3
    super(*args)
  end
  
  # Get the exterior product.
  def self.exterior_product(vec0, vec1)
    [vec0, vec1].each_with_index do |vec, index|
      unless (vec.class == Mageo::Vector3D)
        raise TypeError, "Vector #{index}, #{vec.inspect}."
      end
    end

    bX = vec1[0];
    bY = vec1[1];
    bZ = vec1[2];

    cX = (vec0[1] * bZ - vec0[2] * bY);
    cY = (vec0[2] * bX - vec0[0] * bZ);
    cZ = (vec0[0] * bY - vec0[1] * bX);

    self[cX, cY, cZ]
  end
  class << self
    alias :cross_product :exterior_product
    alias :vector_product :exterior_product
  end

  # Get the scalar triple product.
  def self.scalar_triple_product(vec0, vec1, vec2)
    [vec0, vec1, vec2].each_with_index do |vec, index|
      raise TypeError, "#{index}th vector: #{vec.inspect}" unless (vec.class == Mageo::Vector3D)
    end

    vec0.inner_product(vec1.exterior_product(vec2))
  end

  # Get the angle with radian between self and other vectors.
  def self.angle_radian(vec0, vec1)
    [vec0, vec1].each_with_index do |vec, index|
      raise TypeError, "#{index}th vector: #{vec.inspect}" unless (vec.class == Mageo::Vector3D)
      raise ZeroOperation, "#{index}th vector: #{vec.inspect}" if (vec.r == 0.0)
    end

    Math::acos(vec0.inner_product(vec1) / (vec0.r * vec1.r))
  end

  # Get the angle with degree between self and other vectors.
  def self.angle_degree(vec0, vec1)
    [vec0, vec1].each_with_index do |vec, index|
      raise TypeError, "#{index}th vector: #{vec.inspect}" unless (vec.class == Mageo::Vector3D)
      raise ZeroOperation, "#{index}th vector: #{vec.inspect}" if (vec.r == 0.0)
    end

    self.angle_radian(vec0, vec1) * (180.0 / Math::PI)
  end

  # Instance methods

  def [](index)
    raise RangeError, "index: #{index}." if (index < 0 || 2 < index)
    super index
  end
  
  def []=(index, val)
    raise RangeError, "index: #{index}." if (index < 0 || 2 < index)
    super index, val
  end
  
  
  # ベクトルが等しいかチェック。
  # other として Mageo::Vector3D クラス以外のインスタンス渡すと Vector3D::TypeError。
  # 両者の差分ベクトルの長さが tolerance 以下という判定になる。
  def equal_in_delta?(other, tolerance = 0.0)
    raise TypeError if (other.class != Mageo::Vector3D)
    return (other - self).r <= tolerance
  end

  # Vectorクラスで用意されているメソッドは Vectorクラスインスタンスを返すようになっているので、
  # Mageo::Vector3D クラスインスタンスを返すようにした + メソッド。
  def +(vec)
    unless (vec.class == Mageo::Vector3D)
      raise TypeError, "#{vec.inspect}."
    end
    super(vec).to_v3d
  end

  # Vectorクラスで用意されているメソッドは Vectorクラスインスタンスを返すようになっているので、
  # Mageo::Vector3D クラスインスタンスを返すようにした - メソッド。
  def -(vec)
    unless (vec.class == Mageo::Vector3D)
      raise TypeError, "#{vec.inspect}."
    end
    super(vec).to_v3d
  end

  # Vectorクラスで用意されているメソッドは Vectorクラスインスタンスを返すようになっているので、
  # Mageo::Vector3D クラスインスタンスを返すようにした * メソッド。
  # Argument 'val' must have :to_f method.
  def *(val)
    #raise TypeError if (val.class != Float)
    raise TypeError unless val.methods.include?(:to_f)
    super(val.to_f).to_v3d
  end

  # Vectorクラスで用意されているメソッドは Vectorクラスインスタンスを返すようになっているので、
  # Mageo::Vector3D クラスインスタンスを返すようにした clone メソッド。
  def clone
    super().to_v3d
  end

  # Convert to Mageo::Vector3DInternal. Non-destructive.
  def to_v3di(axes)
    #pp axes.is_a?(Mageo::Axes)
    raise TypeError unless axes.is_a?(Mageo::Axes)

    axes = axes.to_a
    Mageo::Vector3DInternal[ *(Malge::SimultaneousEquations.cramer(axes.transpose, self)) ]
  end

  #Return size, always 3.
  def size
    return 3
  end

  # Get the exterior product.
  def exterior_product(vec)
    self.class.exterior_product(self, vec)
  end
  alias :cross_product :exterior_product
  alias :vector_product :exterior_product

  def scalar_triple_product(vec0, vec1)
    self.class.scalar_triple_product(self, vec0, vec1)
  end

  def angle_radian(vec)
    self.class.angle_radian(self, vec)
  end

  def angle_degree(vec)
    self.class.angle_degree(self, vec)
  end

  #3次元極座標への変換した Mageo::Polar3D インスタンスを返す。
  def to_p3d
    r = self.r
    if r == 0.0
      theta = 0.0
      phi = 0.0
    else
      theta = Mageo::Polar2D.minimum_radian(Math::acos(self[2] / r))
      phi = Vector[ self[0], self[1] ].to_p2d.theta
    end
    Mageo::Polar3D.new(r, theta, phi)
  end

  #x, y, z 軸のいずれかで self を回転する。破壊的。
  #axis は 0, 1, 2 のいずれかで、それぞれ x, y, z軸を示す。
  #radian は回転する角度で、原点から軸の伸びる方向に対して右ねじ方向を正とする。
  #すなわち、軸の正の値の位置から原点を見たとき、左回りが正である。
  #e.g., y軸中心で回転し、z軸を x軸になるように変換。
  # self.rotate_axis!(1, 0.5*PI)
  def rotate_axis!(axis, radian)
    raise RangeError, "Axis id is #{axis}." if (axis < 0 || 2 < axis)
    #axis1, axis2 はそれぞれ、 x軸から見て y軸, z軸。y に対する z, x。z に対する x, y。
    axis1 = (axis + 1) % 3
    axis2 = (axis + 2) % 3

    tmp = Array.new(3)
    tmp[ axis  ] = self[ axis  ]
    tmp[ axis1 ] = Math::cos(radian) * self[ axis1 ] - Math::sin(radian) * self[ axis2 ]
    tmp[ axis2 ] = Math::sin(radian) * self[ axis1 ] + Math::cos(radian) * self[ axis2 ]
    tmp.to_v3d
    self[0] = tmp[0]
    self[1] = tmp[1]
    self[2] = tmp[2]
  end

  #x, y, z 軸のいずれかで self を回転した座標を返す。非破壊的。
  #axis は 0, 1, 2 のいずれかで、それぞれ x, y, z軸を示す。
  #radian は回転する角度で、原点から軸の伸びる方向に対して右ねじ方向を正とする。
  #すなわち、軸の正の値の位置から原点を見たとき、左回りが正である。
  #e.g., y軸中心で回転し、z軸を x軸になるように変換。
  # self.rotate_axis(1, 0.5*PI)
  def rotate_axis(axis, radian)
    tmp = Marshal.load(Marshal.dump(self))
    tmp.rotate_axis!(axis, radian)
    tmp
  end
end
