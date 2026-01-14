# frozen_string_literal: true

require 'spec_helper'

RSpec.describe VegetableBox::Helpers::FormattingHelper do
  describe '.format_order' do
    let(:order) do
      [
        { name: 'Carrot', amount: 2, unit: 'kg', net_price: 3.5 },
        { name: 'Potato', amount: 5, unit: 'kg', net_price: 7.0 }
      ]
    end

    it 'formats the order items with two line breaks between each' do
      expected = "1. Carrot | 2 kg | 3.5 EUR\r\n\r\n2. Potato | 5 kg | 7.0 EUR"
      result = described_class.format_order(order)
      expect(result).to eq(expected)
    end

    it 'returns an empty string for an empty order' do
      expect(described_class.format_order([])).to eq('')
    end

    it 'handles missing fields gracefully' do
      incomplete_order = [{ name: nil, amount: nil, unit: nil, net_price: nil }]
      expected = '1. N/A | N/A N/A | N/A EUR'
      expect(described_class.format_order(incomplete_order)).to eq(expected)
    end
  end
end
