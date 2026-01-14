# frozen_string_literal: true

require 'spec_helper'

RSpec.describe VegetableBox::Api::Authentication do
  subject(:authentication) { described_class.new(agent, config) }

  let(:cookie_jar) { instance_double('Mechanize::CookieJar') }
  let(:agent) { instance_double('Mechanize', cookie_jar: cookie_jar) }
  let(:config) do
    instance_double(
      'VegetableBox::Configuration',
      username: 'test_user',
      password: 'test_password'
    )
  end

  describe '#login' do
    it 'sends a POST request with the correct parameters' do
      login_url = '/proxy/user/login'
      expect(agent).to receive(:post).with(
        login_url,
        {
          username: 'test_user',
          password: 'test_password'
        }
      )

      authentication.login(login_url)
    end
  end

  describe '#logout' do
    it 'sends a GET request and clears the cookie jar' do
      logout_url = '/proxy/user/logout'
      expect(agent).to receive(:get).with(logout_url, {})
      expect(cookie_jar).to receive(:clear!)

      authentication.logout(logout_url)
    end
  end
end
