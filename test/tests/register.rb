require_relative '../test_helper'

class TestRegister < Minitest::Unit::TestCase
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
