require 'mageo/vector3d.rb'

class Array
	def to_v3di
		Vector3DInternal[ *self ]
	end
end

# 内部座標系( internal coordinate ) でのベクトルを表現するクラス。
# 直交座標系とは違い、内積・外積などの角度を含む演算が無効。
# (直交座標と間違えて)内部座標で内積を求めるなど誤った演算を例外で止めるのが目的。
# 座標軸の情報は自身では持たない。
# Actually, this class is very similar to Array class, except for +, -, and * methods.
# Vector, Vector3D との混在計算は例外を発生。
#
# 軸の情報は持たない。
# 軸に関係ない抽象的な内部座標について議論することもありうるし、
# 軸情報が必要なのは to_v3d メソッドくらいなので。
class Vector3DInternal < Vector3D
	class RangeError < Exception; end
	class TypeError < Exception; end

	#要素数3以外では例外 Vector3DInternalSizeError を発生。
	def self.[]( *args )
		raise RangeError unless args.size == 3
		super *args
	end

	## Return order of vector. In this class, always three.
	#def size
	#	return 3
	#end

	# Return self.
	def to_v3di
		return self
	end

	# Convert to Vector3D. Non-destructive.
	def to_v3d( axes )
		result = [ 0.0, 0.0, 0.0 ]
		3.times do |i|
			3.times do |j|
				result[i] += ( self[j] * axes[j][i] )
			end
		end
		Vector3D[ *result ]
	end

	## Return an array converted from self.
	#def to_a
	#	@coords
	#end

	## Check the same vector self and other.
	## Return false if the size of other is not three.
	#def ==( other )
	#	return false if other.size != 3
	#	3.times { |i|
	#		return false if self[i] != other[i]
	#	}
	#	return true
	#end

	#0〜2 以外の要素にアクセスしようとすると例外 Vector3DInternal::RangeError を発生。
	def []( index )
		raise RangeError if ( index < 0 || 2 < index )
		super index
	end

	#0〜2 以外の要素にアクセスしようとすると例外 Vector3DInternal::RangeError を発生。
	def []=( index, val )
		raise RangeError if ( index < 0 || 2 < index )
		super index, val
	end

	#ベクトルとしての加算
	def +(vec)
		unless vec.class == Vector3DInternal
			raise TypeError,
				"Argument: #{vec.inspect}, #{vec.class}."
		end
		result = Vector3DInternal[0.0, 0.0, 0.0]
		3.times do |i|
			result[ i ] = (self[ i ] + vec[ i ])
		end
		result
	end

	#ベクトルとしての減算
	def -( vec )
		unless vec.class == Vector3DInternal
			raise TypeError,
				"Argument: #{vec.inspect}, #{vec.class}."
		end
		result = Vector3DInternal[0.0, 0.0, 0.0]
		3.times do |i|
			result[ i ] = (self[ i ] - vec[ i ])
		end
		result
	end

	#ベクトルとしての乗算
	def *( val )
		result = Vector3DInternal[0.0, 0.0, 0.0]
		3.times do |i|
			result[ i ] = ( self[ i ] * val )
		end
		result
	end

	## each method
	#def each
	#	@coords.each { |i|
	#		yield( i )
	#	}
	#end

	#private
	##
	#def initialize( a, b, c )
	#	@coords = [ a, b, c ]
	#end

end
