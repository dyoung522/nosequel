require 'minitest/autorun'
require "minitest/reporters"
require 'nosequel'

if ENV['RUBYMINE_TESTUNIT_REPORTER']
  MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter
else
  #MiniTest::Reporters.use! MiniTest::Reporters::DefaultReporter.new
  #MiniTest::Reporters.use! MiniTest::Reporters::ProgressReporter.new
  MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new
end

module TestSetup
  def setup
    @table = :test
    @data = NoSequel.register(@table, db_type: 'sqlite', db_name: 'test.db')

    (1..4).each { |i| @data["test#{i}".to_sym] = "value#{i}" }
  end

  def teardown
    NoSequel.drop!(@table)
  end
end

# Run all tests in the tests directory (and any subdirectories)
Dir.glob('./test/tests/**/*.rb').each { |file| require file}

