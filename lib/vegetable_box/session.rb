# frozen_string_literal: true

module VegetableBox
  class Session
    attr_reader :agent, :config, :urls

    def initialize(config)
      @config    = config
      @agent     = build_agent
      @urls      = Urls.new(config.base_url)
      @logged_in = false
    end

    def login
      authentication.login(urls.login_url)
      @logged_in = true
    end

    def logout
      authentication.logout(urls.logout_url)
      @logged_in = false
    end

    def logged_in?
      @logged_in
    end

    def order_list(for_specific_date)
      order.list(urls.order_list_url, for_specific_date)
    end

    def current_order(order_id)
      order.current_order(urls.order_details_url, urls.order_list_url, order_id)
    end

    def notify_current_order
      order_data = current_order(nil)
      notifier.send_current_order(order_data)
    end

    private

    def authentication
      Api::Authentication.new(agent, config)
    end

    def order
      Api::Order.new(agent, config)
    end

    def notifier
      Notifiers::TrelloEmail.new(config)
    end

    def build_agent
      Mechanize.new do |agent|
        config.mechanize_options.each do |key, value|
          agent.send("#{key}=", value)
        end

        agent
      end
    end
  end
end
