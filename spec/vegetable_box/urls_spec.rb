# frozen_string_literal: true

require 'spec_helper'

RSpec.describe VegetableBox::Urls do
  let(:base_url) { 'https://example.com' }
  let(:urls) { VegetableBox::Urls.new(base_url) }

  describe '#login_url' do
    it 'returns the correct login URL' do
      expect(urls.login_url).to eq('https://example.com/proxy/user/login')
    end
  end

  describe '#logout_url' do
    it 'returns the correct logout URL' do
      expect(urls.logout_url).to eq('https://example.com/proxy/user/logout')
    end
  end

  describe '#order_list_url' do
    it 'returns the correct order list URL' do
      expect(urls.order_list_url).to eq('https://example.com/proxy/dates/list')
    end
  end

  describe '#order_details_url' do
    it 'returns the correct order details URL' do
      expect(urls.order_details_url).to eq('https://example.com/proxy/order/details')
    end
  end
end
