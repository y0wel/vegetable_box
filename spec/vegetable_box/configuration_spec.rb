# frozen_string_literal: true

require 'spec_helper'

RSpec.describe VegetableBox::Configuration do
  let(:configuration) { described_class.new }

  describe 'constants' do
    it 'defines DEFAULT_VALUES[:base_url]' do
      expect(described_class::DEFAULT_VALUES[:base_url]).to eq('https://www.diegemuesekiste.de')
    end

    it 'defines DEFAULT_VALUES[:mechanize_options]' do
      expect(described_class::DEFAULT_VALUES[:mechanize_options]).to eq({ user_agent_alias: 'Mac Safari' })
    end
  end

  it 'defines multiple configurable properties' do
    expected_keys = %i[
      username
      password
      base_url
      tour_id
      address_id
      delivery_date
      smtp
      trello_inbox_mail
      mechanize_options
    ]
    expect(described_class::CONFIG_KEYS).to match_array(expected_keys)
  end
end
