require 'spec_helper'
require 'cinch-storage'

module Cinch
  module Extensions
    describe Storage do

      subject(:data) { Storage.register(:test) }

      before(:each) { data[:test1] = 'value1' }
      after(:each) { Storage.drop!(:test) }

      context 'registering a table' do

        it "should exist" do
          Storage.exists?(:test).should be_true
        end

        it "removes the table after drop!" do
          Storage.register(:drop_test)
          Storage.drop!(:drop_test)
          Storage.exists?(:drop_test).should be_false
        end

        it "a non-existant table should not exist" do
          Storage.exists?(:bogus_table).should be_false
        end

      end

      context "creating and using data"  do

        it "column should exist" do
          data.exists?(:test1).should be_true
        end

        it "retrieves an existing key" do
          data[:test1].should == 'value1'
        end

        it "adds a key/value pair" do
          data[:newkey] = 'new key value'
          data[:newkey].should == 'new key value'
        end

        it "updates an existing key/value pair" do
          data[:test1] = 'new value'
          data[:test1].should == 'new value'
        end

        it "deletes the key upon delete" do
          data.delete(:test1)
          data.exists?(:test1).should be_false
        end

      end

      context "using query methods" do

        before(:each) do
          data[:test2] = 'value2'
          data[:test3] = 'value3'
          data[:test4] = 'value4'
        end

        it "returns an array of keys with #keys" do
          data.keys.should == %w( test1 test2 test3 test4 )
        end

        it "returns an array of values with #values" do
          data.values.should == %w( value1 value2 value3 value4 )
        end

        context "acts like an enumerator" do
          it "responds to Hash methods" do
            data.respond_to?(:keys).should be_true
          end

          it "handles each" do
            expect { |b| data.each(&b) }.to(
                yield_successive_args( ['test1', 'value1'],
                                       ['test2', 'value2'],
                                       ['test3', 'value3'],
                                       ['test4', 'value4'] )
            )
          end

          it "handles map" do
            new_data = [ data.map{ |key, value| value.upcase } ]
            expect { |b| new_data.each(&b) }.to(
                yield_successive_args %w(VALUE1 VALUE2 VALUE3 VALUE4)
            )
          end

          it "doesn't respond to bogus methods" do
            data.respond_to?(:foo).should be_false
            expect { data.foo }.to raise_error(NoMethodError)
          end

        end
      end
    end
  end
end


