# frozen_string_literal: true

require 'spec_helper'

RSpec.describe VegetableBox::Api::Order do
  let(:agent) { instance_double('Mechanize') }
  let(:config) { double('Config', delivery_date: nil) }
  let(:order_api) { described_class.new(agent, config) }

  let(:events_response) do
    {
      'data' => {
        'events' => [
          {
            'date' => '2026-01-23',
            'tours' => [
              {
                'addressId' => 1,
                'id' => 2,
                'orders' => [
                  { 'id' => 42 }
                ]
              }
            ]
          }
        ]
      }
    }
  end

  let(:products_response) do
    {
      'data' => {
        'products' => [
          {
            'amount' => 2,
            'price' => 3.5,
            'information' => { 'name' => 'Carrot' },
            'unit' => { 'unit' => 'kg' }
          },
          {
            'amount' => 0,
            'price' => 1.0,
            'information' => { 'name' => 'Potato' },
            'unit' => { 'unit' => 'kg' }
          }
        ]
      }
    }
  end

  before do
    allow(order_api).to receive(:fetch_order_events).and_return(events_response.dig('data', 'events'))
    allow(order_api).to receive(:fetch_order_products).and_return(products_response.dig('data', 'products'))
  end

  describe '#list' do
    it 'returns all orders for all events by default' do
      result = order_api.list('url', false)
      expect(result).to eq([{ 'id' => 42 }])
    end

    it 'filters events by delivery_date if for_specific_date is true' do
      allow(order_api).to receive(:delivery_date).and_return('2026-01-23')
      result = order_api.list('url', true)
      expect(result).to eq([{ 'id' => 42 }])
    end
  end

  describe '#current_order' do
    it 'returns formatted order items for the current order' do
      allow(order_api).to receive(:delivery_date).and_return('2026-01-23')
      result = order_api.current_order('details_url', 'list_url', nil)
      expect(result).to eq([
                             {
                               delivery_date: '2026-01-23',
                               name: 'Carrot',
                               amount: 2,
                               gross_price: 3.5,
                               net_price: 7.0,
                               unit: 'kg'
                             }
                           ])
    end
  end

  describe '#build_order_items' do
    it 'returns formatted order items, skipping zero-amount products' do
      allow(order_api).to receive(:delivery_date).and_return('2026-01-23')
      products = products_response.dig('data', 'products')
      result = order_api.send(:order_items_from_products, products)
      expect(result).to eq([
                             {
                               delivery_date: '2026-01-23',
                               name: 'Carrot',
                               amount: 2,
                               gross_price: 3.5,
                               net_price: 7.0,
                               unit: 'kg'
                             }
                           ])
    end
  end
end
