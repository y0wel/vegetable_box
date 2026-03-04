# frozen_string_literal: true

module VegetableBox
  module Api
    class Base
      attr_reader :agent, :config

      def initialize(agent, config)
        @agent  = agent
        @config = config
      end

      def get(path, params = {})
        agent.get(path, params)
      end

      def post(path, params = {})
        agent.post(path, params)
      end
    end
  end
end
