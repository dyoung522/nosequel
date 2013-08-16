require 'spec_helper'
require 'cinch/extensions/storage'

module Cinch
  module Extensions

    describe Storage do
      it "creates a storage object" do
        storage = Storage.new
        storage.class == 'Storage'
      end
    end

  end
end

