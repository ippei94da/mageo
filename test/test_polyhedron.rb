#! /usr/bin/env ruby
# coding: utf-8

require "test/unit"
require "helper"
require "mageo/polyhedron.rb"

# initialize でインスタンスを生成できないことのみテストする。
# その他の機能はサブクラスでテスト。
class TC_Polyhedron < Test::Unit::TestCase
  def test_initialize
    assert_raise( NotImplementedError ) { Polyhedron.new }
  end
end
