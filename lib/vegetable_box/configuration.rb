# frozen_string_literal: true

module VegetableBox
  class Configuration
    DEFAULT_VALUES = {
      base_url:          'https://www.diegemuesekiste.de',
      mechanize_options: { user_agent_alias: 'Mac Safari' }
    }.freeze

    CONFIG_KEYS = [
      :username,
      :password,
      :base_url,
      :tour_id,
      :address_id,
      :delivery_date,
      :mechanize_options
    ].freeze

    attr_accessor(*CONFIG_KEYS)

    def initialize(params = {})
      params = DEFAULT_VALUES.merge(params)
      @username          = params[:username]
      @password          = params[:password]
      @base_url          = params[:base_url]
      @tour_id           = params[:tour_id]
      @address_id        = params[:address_id]
      @delivery_date     = params[:delivery_date]
      @mechanize_options = params[:mechanize_options]
    end
  end
end
