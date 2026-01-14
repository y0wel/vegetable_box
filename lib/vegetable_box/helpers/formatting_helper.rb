# frozen_string_literal: true

module VegetableBox
  module Helpers
    class FormattingHelper
      def self.format_order(order)
        order.map.with_index do |item, index|
          name      = item[:name] || 'N/A'
          amount    = item[:amount] || 'N/A'
          unit      = item[:unit] || 'N/A'
          net_price = item[:net_price] || 'N/A'

          "#{index + 1}. #{name} | #{amount} #{unit} | #{net_price} EUR"
        end.join("\r\n\r\n")
      end
    end
  end
end
