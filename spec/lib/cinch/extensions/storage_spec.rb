require 'spec_helper'
require 'cinch/extensions/storage'

module Cinch
  module Extensions
    describe Storage do
      subject(:data) { Storage.register(:test) }

      before(:each) { data[:mykey] = 'test' }
      after(:all)   { Storage.drop!(:test)}

      context 'registering a table' do
        it { should_not be_nil    }

        it "column should exist" do
          data.exists?(:mykey).should be_true
        end

        it "retrieves an existing key" do
          data[:mykey].should == 'test'
        end

        it "adds a key/value pair" do
          data[:newkey] = 'new key value'
          data[:newkey].should == 'new key value'
        end

        it "updates an existing key/value pair" do
          data[:mykey] = 'new value'
          data[:mykey].should == 'new value'
        end

      end

    end
  end
end


