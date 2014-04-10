require 'spec_helper'

module Spree
  describe Order do

    let!(:variant) { create(:variant) }
    let!(:stock_item) { variant.stock_items.first }

    it "pushes serialized JSON after saved" do
      expect(Spree::Hub::StockItemSerializer).to receive(:push_it).with(stock_item)
      stock_item.save!
    end

  end
end
