# frozen_string_literal: true

require_relative 'base'

module VegetableBox
  module Api
    class Order < VegetableBox::Api::Base
      def list(url, for_specific_date)
        events = fetch_order_events(url)
        events = for_specific_date ? events.select { |event| event['date'] == delivery_date } : events
        events
          .flat_map { |event| event['tours'] }
          .flat_map { |tour| tour['orders'] }
      end

      def current_order(url_details, url_list, order_id)
        order_id ||= current_order_id(url_list)

        order_details = fetch_order_events(url_list).first['tours']
        address_id = order_details.first['addressId']
        tour_id = order_details.first['id']

        current_order_url = order_product_url(url_details, order_id, address_id, tour_id)
        products = fetch_order_products(current_order_url)

        order_items_from_products(products)
      end

      private

      def fetch_order_events(url)
        order_list = get(url)
        order_list_as_json = JSON.parse(order_list.body)
        order_list_as_json.dig('data', 'events') || []
      end

      def fetch_order_products(url)
        current_order = get(url)
        current_order_as_json = JSON.parse(current_order.body)
        current_order_as_json.dig('data', 'products') || []
      end

      def current_order_id(url)
        events = fetch_order_events(url)
        events
          .select { |event| event['date'] == delivery_date }
          .flat_map { |event| event['tours'] }
          .flat_map { |tour| tour['orders'] }
          .first['id']
      end

      def order_product_url(url, order_id, address_id, tour_id)
        "#{url}?orderId=#{order_id}&addressId=#{address_id}&tourId=#{tour_id}&deliveryDate=#{delivery_date}"
      end

      def order_items_from_products(products)
        products.map do |product|
          next if product['amount'].zero?

          net_price = product['price'] * product['amount']

          {
            delivery_date: delivery_date,
            name: product.dig('information', 'name'),
            amount: product['amount'],
            gross_price: product['price'],
            net_price: net_price.round(2),
            unit: product.dig('unit', 'unit')
          }
        end.compact
      end

      def delivery_date
        return default_delivery_date if config.delivery_date.nil?

        normalize_delivery_date(config.delivery_date)
      end

      def normalize_delivery_date(date)
        date_str = date.to_s
        Date.parse(date_str).strftime('%Y-%m-%d')
      rescue ArgumentError
        default_delivery_date
      end

      def default_delivery_date
        today = Date.today
        saturday = today + ((6 - today.wday) % 7)
        saturday.strftime('%Y-%m-%d')
      end
    end
  end
end
