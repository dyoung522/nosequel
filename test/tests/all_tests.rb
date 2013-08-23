class TestNoSequelConfig < Minitest::Unit::TestCase
  def test_config_via_register
    ( db_name, db_type, db_user, db_host ) = %w(testing mysql test)
    config_string = NoSequel.make_config_string( db_type: db_type,
                                                 db_name: db_name,
                                                 db_user: db_user,
                                                 db_host: db_host )
    assert_equal "#{db_type}://#{db_user}/#{db_name}", config_string
  end

  def test_drop_method_raises_error_before_register
    out, err = capture_io do
      assert_raises(RuntimeError) { NoSequel.drop!(:test) }
    end
    assert_match err, 'must call register'
  end

  def test_exists_method_raises_error_before_register
    out, err = capture_io do
      assert_raises(RuntimeError) { NoSequel.exists?(:test) }
    end
    assert_match err, 'must call register'
  end
end

class TestNoSequelModule < Minitest::Unit::TestCase
  include TestSetup

  def test_exists
    assert NoSequel.exists?(@table), "table '#{@table}' should exist"
  end

  def test_remove_table_after_drop
    NoSequel.register(:drop_test)
    assert NoSequel.exists?(:drop_test), "table 'drop_test' should now exist"

    NoSequel.drop!(:drop_test)
    refute NoSequel.exists?(:drop_test), "table 'drop_test' should no longer exist"
  end

  def test_nontexistant_table_should_not_exist
    refute NoSequel.exists?(:bogus_table), "table :bogus_table should not exist"
  end

end

class TestNoSequelData < Minitest::Unit::TestCase
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
