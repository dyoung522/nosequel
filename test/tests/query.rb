require_relative '../test_helper'

class TestNoSequelQuery < Minitest::Unit::TestCase
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

