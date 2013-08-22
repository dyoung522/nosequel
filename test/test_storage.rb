require 'minitest/autorun'
require 'minitest/reporters'
require 'cinch-storage'

MiniTest::Reporters.use!

module Cinch
  module Extensions

    module TestSetup
      def setup
        @table = :test
        @data = Storage.register(@table, db_type: 'sqlite', db_name: 'test.db')

        (1..4).each { |i| @data["test#{i}".to_sym] = "value#{i}" }
      end

      def teardown
        Storage.drop!(@table)
      end
    end

    class TestStorageModule < Minitest::Unit::TestCase
      include TestSetup

      def test_storage_exists
        assert Storage.exists?(@table), "table '#{@table}' should exist"
      end

      def test_remove_table_after_drop
        Storage.register(:drop_test)
        assert Storage.exists?(:drop_test), "table 'drop_test' should now exist"

        Storage.drop!(:drop_test)
        refute Storage.exists?(:drop_test), "table 'drop_test' should no longer exist"
      end

      def test_nontexistant_table_should_not_exist
        refute Storage.exists?(:bogus_table), "table :bogus_table should not exist"
      end

    end

    class TestStorageData < Minitest::Unit::TestCase
      include TestSetup

      def test_column_should_exist
        assert @data.exists?(:test1), "@data[:test1] should exist"
      end

      def test_retrieve_column_value
        assert_equal 'value1', @data[:test1], "@data[:test1] should return 'value1'"
      end

      def test_add_a_key_value_pair
        @data[:newkey] = 'new key value'
        assert_equal 'new key value', @data[:newkey], "We should be able to set a new key/value pair at will"
      end

      def test_update_an_existing_key_value_pair
        @data[:test1] = 'new value'
        assert_equal 'new value', @data[:test1], "We should be able to add a new value to an existing key"
      end

      def test_delete_key
        @data.delete(:test1)
        refute @data.exists?(:test1)
      end

    end

    class TestStorageQuery < Minitest::Unit::TestCase
      include TestSetup

      def test_data_responds_to_Hash_methods
        assert_respond_to @data, :keys
        assert_respond_to @data, :values
      end

      def test_keys_method_returns_an_array_of_keys
        assert_equal %w( test1 test2 test3 test4 ), @data.keys
      end

      def test_array_method_returns_an_array_of_values
        assert_equal %w( value1 value2 value3 value4 ), @data.values
      end

      def test_data_handles_next
        enum = @data.each

        assert_equal %w(test1 value1), enum.next
        assert_equal %w(test2 value2), enum.next
        assert_equal %w(test3 value3), enum.next
        assert_equal %w(test4 value4), enum.next

        assert_raises(StopIteration) { enum.next }
      end

      def test_data_handles_map
        assert_equal %w(VALUE1 VALUE2 VALUE3 VALUE4), @data.map { |k,v| v.upcase }
      end

      def test_data_doesnt_respond_to_bogus_methods
        refute_respond_to @data, :foo
        assert_raises(NoMethodError) { @data.foo }
      end

    end
  end
end

