# frozen_string_literal: true

module VegetableBox
  class Urls
    attr_reader :base_url

    def initialize(base_url)
      @base_url = base_url
    end

    def login_url
      "#{base_url}/proxy/user/login"
    end

    def logout_url
      "#{base_url}/proxy/user/logout"
    end

    def order_list_url
      "#{base_url}/proxy/dates/list"
    end

    def order_details_url
      "#{base_url}/proxy/order/details"
    end
  end
end
