require 'spec_helper'

module Spree
  module Hub
    describe Handler::SetInventoryHandler do

      let(:message) {::Hub::Samples::Inventory.request}
      let(:handler) { Handler::SetInventoryHandler.new(message.to_json) }

      describe "process" do

        context "with stock item present" do
          let!(:variant) { create(:variant, :sku => 'SPREE-T-SHIRT') }

          it "will set the inventory to the supplied amount" do
            expect{handler.process}.to change{variant.reload.count_on_hand}.from(5).to(93)
          end

          it "returns a Hub::Responder with a proper message" do
            responder = handler.process
            expect(responder.summary).to eql "Set inventory for Product with id SPREE-T-SHIRT from 5 to 93"
            expect(responder.code).to eql 200
          end

        end

      end

    end
  end
end
