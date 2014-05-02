require 'spec_helper'

module Spree
  module Hub
    describe Handler::UpdateShipmentHandler do
      let(:message) {::Hub::Samples::Shipment.request}
      let(:handler) { Handler::UpdateShipmentHandler.new(message.to_json) }

      describe "process" do

        context "with all reference data present" do

          let!(:order) do
            order = create(:completed_order_with_totals, number: message["shipment"]["order_id"] )
            2.times do
              create(:line_item, order: order)
            end
            order.update!
            order.reload
          end

          let!(:shipping_method) { create(:shipping_method, name: 'UPS Ground (USD)')}
          let!(:country) { Spree::Country.first }
          let!(:state) { create(:state, :country => country, name: "California", abbr: "CA") }
          let!(:shipment) do
            create(:shipment,
              number: message['shipment']['id'],
              order: order,
              inventory_units: [create(:inventory_unit)]
            )
          end

          before do
            Spree::Variant.stub(:find_by_sku).and_return(order.variants.first)
            shipment.stub(:order).and_return order
          end

          it "will return a proper message" do
            responder = handler.process
            expect(responder.summary).to eql "Updated shipment #{shipment.number}"
            expect(responder.code).to eql 200
          end

        end

      end

    end
  end
end
