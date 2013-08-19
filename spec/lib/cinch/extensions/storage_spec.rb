require 'spec_helper'
require 'cinch/extensions/storage'

module Cinch
  module Extensions
    describe Storage do

      subject(:data) { Storage.register(:test) }

      before(:each)  { data[:testkey] = 'testing' }
      after(:all)    { Storage.drop!(:test)    }

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
          data.exists?(:testkey).should be_true
        end

        it "retrieves an existing key" do
          data[:testkey].should == 'testing'
        end

        it "adds a key/value pair" do
          data[:newkey] = 'new key value'
          data[:newkey].should == 'new key value'
        end

        it "updates an existing key/value pair" do
          data[:testkey] = 'new value'
          data[:testkey].should == 'new value'
        end

      end
    end
  end
end


