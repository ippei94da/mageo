#! /usr/bin/env ruby
# coding: utf-8

#3次元空間中の3角形を表現するクラス。
#
#法線ベクトル( Vector3D クラスインスタンス )を返すメソッドは定義しない。
#  法線ベクトルは2通りの方向を取りうるため。
#  initialize 時に点の指定の順序を決めることで定義はできるが、
#  そうすると簡潔性が損なわれる。
class Mageo::Triangle
  attr_reader :vertices

  class InitializeError < Exception; end
  class LinearException < Exception; end
  class TypeError < Exception; end
  #class InPlaneError < Exception; end
  class NoIntersectionError < Exception; end

  #An argument 'vertices' can be Array of 3 items, Vector of 3 items,
  # or Vector3D class instance, which have [] and map methods.
  #当面は Array を前提とする。
  #座標が整数で入っていたとしても内部的には Float に変換して使用する。
  #3点が1直線上に並んでいて三角形を囲まない場合は
  #例外 Mageo::Triangle::LinearException を投げる。
  def initialize( vertices )
    raise InitializeError unless vertices.methods.include?( :size )
    raise InitializeError if vertices.size != 3
    vertices.each do |pos|
      raise InitializeError if pos.size != 3
      raise InitializeError unless pos.methods.include?( :[] )
      raise InitializeError unless pos.methods.include?( :map )
    end
    @vertices = vertices.map do |pos| 
      ( pos.map { |i| i.to_f }) . to_v3d
    end

    #Checking on linear.
    edge1 = @vertices[1] - @vertices[0]
    edge2 = @vertices[2] - @vertices[0]
    if ( Vector3D[0.0, 0.0, 0.0] == Vector3D.vector_product( edge1, edge2 ))
      raise LinearException
    end

  end

  #引数で与えられた 2 つの座標が、三角形の面に対して同じ側にあれば true を返す。
  #どちらか、もしくは両方が、面上の点(当然頂点、辺上を含む)であれば必ず false を返す。
  def same_side?( pos0, pos1 )
    raise TypeError if pos0.class != Vector3D
    raise TypeError if pos1.class != Vector3D

    edge1 = @vertices[1] - @vertices[0]
    edge2 = @vertices[2] - @vertices[0]
    pos0  = pos0.to_v3d - @vertices[0]
    pos1  = pos1.to_v3d - @vertices[0]

    triple_product_pos0 = Vector3D.scalar_triple_product( edge1, edge2, pos0 )
    triple_product_pos1 = Vector3D.scalar_triple_product( edge1, edge2, pos1 )
    if triple_product_pos0 * triple_product_pos1 > 0
      return true
    else
      return false
    end
  end

  # 3点で張られる面上にあり、三角形の内側にあれば true を返す。
  # pos が Vector3D クラスインスタンスでなければ例外。
  # ただし、面の法線方向には tolerance だけの許容値を設ける。
  # 計算誤差の問題のため、これを設定しないと殆ど真とならない。
  def include?(pos, tolerance)
    raise TypeError if pos.class != Vector3D

    axes = internal_axes
    #一次独立チェックは initialize 時にされている筈。

    pos   = (pos - @vertices[0]).to_v3d
    internal_pos = pos.to_v3di(axes)
    return false if internal_pos[2].abs > tolerance #面の外にあれば false
    return false if (internal_pos[0] < 0.0 )
    return false if (1.0 < internal_pos[0])
    return false if (internal_pos[1] < 0.0 )
    return false if (1.0 < internal_pos[1])
    return false if (1.0 < internal_pos[0] + internal_pos[1])
    #たしざんで 1 いかとか。
    return true
  end

  ## 三角形と線分が交差するか判定する。
  ## 以下の and 条件になる。
  ## - 面と直線が並行でないこと。
  ## - 面と直線の交点が三角形の内側であること
  ## - 面と直線の交点が線分の長さ方向に関して線分と同じ領域にあること
  #def intersect?(segment)
  # 
  #end

  # 三角形を含む面と線分の交点を返す。
  # 交点がない、無数にある、三角形の内側にない、という場合には
  # 例外 NoIntersectionError を返す。
  def intersection(segment, tolerance)
    # 平行のとき、例外。
    raise NoIntersectionError if parallel_segment?(segment)

    # 面内の直線のとき、例外。
    endpoints_v3di = segment.endpoints.map do |v|
      (v - @vertices[0]).to_v3di(internal_axes)
    end
    if ( (endpoints_v3di[0][2] == 0.0) && (endpoints_v3di[1][2] == 0.0) )
      raise NoIntersectionError
    end

    # 面と直線の交点を求める。
    # endpoints_v3di をベクトルと見たとき、 c 軸成分が 0 になるのは
    # ベクトルの何倍か？
    # ゼロ割りになる条件は、ここまでに弾いた条件に含まれる筈。
    c_0 = endpoints_v3di[0][2]
    c_1 = endpoints_v3di[1][2]
    factor = c_0 / (c_0 - c_1)
    intersection = (segment.endpoints[0] + (segment.to_v3d) * factor)

    # 交点が線分上にあるか？すなわち両端点が面を挟んでいるか？
    raise NoIntersectionError if c_0 * c_1 > 0

    # 交点が三角形の内側にあるか？
    if (! include?(intersection, tolerance))
      raise NoIntersectionError
    end

    return intersection
  end

  # 線分と並行であることを判定する。
  # 線分が三角形の面内の場合は false になる。
  def parallel_segment?(segment)
    #p segment.endpoints
    t = segment.endpoints.map{|v|
      v.to_v3di(internal_axes)
    }

    # 傾いてるときは常に false
    return false if t[0][2] != t[1][2]

    # 傾きがない場合、面に含まれていれば false
    return false if t[0][2] == 0.0

    # 残った場合が true
    return true
  end

  # 法線ベクトルの1つを返す。
  # 法線ベクトルは正反対の方向を示す 2つがあるが、
  # 内部的には頂点の順が右ねじとなる方向(正確には外積の定義される方向)
  # のものが選ばれる。
  # また、長さが1に規格化されたものが返される。
  def normal_vector
    edge1 = (@vertices[1] - @vertices[0])
    edge2 = (@vertices[2] - @vertices[1])
    vec = edge1.exterior_product( edge2 )
    normal = vec * (1.0/vec.r)

    return normal
  end

  # 3つの頂点の座標が順不同で対応すれば真を返す。
  # other が Mageo::Triangle クラス以外のインスタンスなら例外 Triangle::TypeError を投げる。
  # MEMO:
  # 当初 eql? という名前を付けていたが、
  # これは hash メソッドと関連があるので危険。
  # よって別の名前の equivalent? というメソッド名にした。
  # しかし eql? に依存したコードが残っているので当面 alias を残す。
  # そのうち obsolete する。
  def equivalent?(other, tolerance = 0.0)
    raise TypeError unless other.class == Mageo::Triangle

    vertices.each do |v_self|
      if (other.vertices.find{|v_other| v_self.equal_in_delta?(v_other, tolerance) })
        next
      else
        return false 
      end
    end
    #return false unless other.vertices.include?(v)
    return true
    
    #vertices.each do |v|
    # return false unless other.vertices.include?(v)
    #end
    #return true
  end
  alias eql? equivalent?

  # 3つの頂点の座標が順序通りに対応すれば真を返す。
  def ==(other)
    vertices.size.times do |i|
      return false unless @vertices[i] == other.vertices[i]
    end
    return true
  end

  def edges
    results = []
    results << Mageo::Segment.new(@vertices[0], @vertices[1])
    results << Mageo::Segment.new(@vertices[1], @vertices[2])
    results << Mageo::Segment.new(@vertices[2], @vertices[0])
    return results
  end

  private

  # 三角形の2辺のベクトルと、これらからなる外積ベクトル、
  # 合計3つのベクトルから Mageo::Axes クラスインスタンスを作る。
  # vertices で取り出せる3頂点のうち、0th 要素を原点とし、
  # 1st, 2nd 要素をそれぞれ順に軸としたものとする。
  def internal_axes
    edge1 = (@vertices[1] - @vertices[0])
    edge2 = (@vertices[2] - @vertices[0])
    return Mageo::Axes.new([edge1, edge2, normal_vector])
  end
end
