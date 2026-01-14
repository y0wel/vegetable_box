# frozen_string_literal: true

require 'mechanize'
require 'date'
require 'json'
require 'mail'

require_relative 'vegetable_box/api/authentication'
require_relative 'vegetable_box/api/base'
require_relative 'vegetable_box/api/order'
require_relative 'vegetable_box/client'
require_relative 'vegetable_box/configuration'
require_relative 'vegetable_box/error'
require_relative 'vegetable_box/helpers/formatting_helper'
require_relative 'vegetable_box/notifiers/trello_email'
require_relative 'vegetable_box/session'
require_relative 'vegetable_box/urls'
require_relative 'vegetable_box/version'

module VegetableBox
  class << self
    def config
      @config ||= VegetableBox::Configuration.new
    end

    def configure
      yield(config)
    end
  end
end
