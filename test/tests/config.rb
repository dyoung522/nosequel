require_relative '../test_helper'

class TestConfigurationMethods < Minitest::Unit::TestCase

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

  # We're testing a private method to be sure it's returning a valid response.
  # If you're reading this, please note that this is a private method and
  # therefore should generally *not* be called directly in your code.
  # You probably want object.sequel if you need direct access to sequel calls.
  def test_private_sequel_url_returns_a_valid_response
    ( db_name, db_type, db_user, db_host ) = %w(testing mysql test)
    config = NoSequel::Configuration.new(
        db_type: db_type,
        db_name: db_name,
        db_user: db_user,
        db_host: db_host
    )
    assert_equal "#{db_type}://#{db_user}/#{db_name}", config.send(:sequel_url)
  end

end
