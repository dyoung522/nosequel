require 'minitest/autorun'
require 'minitest/reporters'
require 'cinch-storage'

MiniTest::Reporters.use!

module Cinch
  module Extensions
    class TestStorage < Minitest::Unit::TestCase
      def setup
        @test = Cinch::Extensions::Storage.register(:test)
        @test[:test1] = 'value1'
      end

      def test_storage_exists
        assert true, Storage.exists?(:test)
      end

    end
  end
end

