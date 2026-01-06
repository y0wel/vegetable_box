# frozen_string_literal: true

require_relative 'base'

module VegetableBox
  module Api
    class Authentication < VegetableBox::Api::Base
      def login(url)
        post(
          url,
          {
            username: config.username,
            password: config.password
          }
        )
      end

      def logout(url)
        get(url)
        agent.cookie_jar.clear!
      end
    end
  end
end
