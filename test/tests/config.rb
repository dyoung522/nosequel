require_relative '../test_helper'

class TestConfiguration < Minitest::Unit::TestCase

  def test_returns_valid_configuration_string
    ( db_name, db_type, db_user, db_host ) = %w(testing mysql test)
    config_string = NoSequel.make_config_string(
        db_type: db_type,
        db_name: db_name,
        db_user: db_user,
        db_host: db_host
    )
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
