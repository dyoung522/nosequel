require_relative '../test_helper'

class TestNoSequelWrites < Minitest::Unit::TestCase
  include TestSetup

  Tester = Struct.new(:data)

  def test_non_string_key_raises_error
    assert_raises(ArgumentError) { @data[Struct.new(:data)] }
  end

  def test_serialize_objects_before_write
    @data[:test_object] = Tester.new()
    assert_instance_of Tester, @data[:test_object]
  end

  def test_deserialize_objects_before_read
    @data[:test_object] = Tester.new('hi there')
    assert_equal 'hi there', @data[:test_object].data
  end
end
