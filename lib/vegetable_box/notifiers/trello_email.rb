# frozen_string_literal: true

module VegetableBox
  module Notifiers
    class TrelloEmail
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def send_current_order(order)
        smtp_settings  = config.smtp
        delivery_date  = order.first[:delivery_date]
        formatted_body = Helpers::FormattingHelper.format_order(order)

        Mail.defaults do
          delivery_method :smtp, smtp_settings
        end

        mail = create_mail(delivery_date, formatted_body)
        mail.deliver!
      end

      private

      def create_mail(date, body)
        mail              = Mail.new
        mail.from         = config.smtp[:user_name]
        mail.to           = config.trello_inbox_mail
        mail.subject      = "🥕 Vegetable Box Order for #{date}"
        mail.body         = body
        mail.content_type = 'text/plain; charset=UTF-8'
        mail
      end
    end
  end
end
