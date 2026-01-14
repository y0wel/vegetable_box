# frozen_string_literal: true

require 'mechanize'

module VegetableBox
  class Client
    attr_reader :session

    def initialize(config)
      @session = Session.new(config)
    end

    def login
      session.login
    end

    def logout
      ensured_logged_in!
      session.logout
    end

    def order_list(for_specific_date: true)
      ensured_logged_in!
      session.order_list(for_specific_date)
    end

    def current_order(order_id: nil)
      ensured_logged_in!
      session.current_order(order_id)
    end

    def notify_current_order
      ensured_logged_in!
      session.notify_current_order
    end

    private

    def ensured_logged_in!
      raise VegetableBox::Error::NotLoggedInError unless session.logged_in?
    end
  end
end
