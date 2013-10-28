require 'nosequel'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'

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

    (1..4).each { |i| @data["test#{i}"] = "value#{i}" }
  end

  def teardown
    NoSequel.drop!(@table)
  end
end

