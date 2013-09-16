require_relative '../test_helper'

class TestDataMethods < Minitest::Unit::TestCase
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
    out = @data.delete(:test1)
    refute @data.exists?(:test1)
    assert_equal 'value1', out
  end

end
