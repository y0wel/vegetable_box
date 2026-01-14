# frozen_string_literal: true

RSpec.describe VegetableBox::Session do
  subject(:session) { described_class.new(config) }

  let(:config) do
    VegetableBox::Configuration.new(
      username: 'test_user',
      password: 'test_password'
    )
  end

  describe '#initialize' do
    it 'initializes with the given configuration' do
      expect(session.config).to eq(config)
      expect(session.agent).to be_a(Mechanize)
      expect(session.urls).to be_a(VegetableBox::Urls)
      expect(session.logged_in?).to be false
    end
  end

  describe '#login' do
    it 'logs in successfully' do
      auth_api = instance_double(VegetableBox::Api::Authentication)
      allow(VegetableBox::Api::Authentication).to receive(:new).and_return(auth_api)
      expect(auth_api).to receive(:login).with(session.urls.login_url)
      session.login
      expect(session.logged_in?).to be true
    end
  end

  describe '#logout' do
    before do
      session.instance_variable_set(:@logged_in, true)
    end

    it 'logs out successfully' do
      auth_api = instance_double(VegetableBox::Api::Authentication)
      allow(VegetableBox::Api::Authentication).to receive(:new).and_return(auth_api)
      expect(auth_api).to receive(:logout).with(session.urls.logout_url)
      session.logout
      expect(session.logged_in?).to be false
    end
  end

  describe '#order_list' do
    it 'retrieves the order list for a specific date' do
      order_api = instance_double(VegetableBox::Api::Order)
      allow(VegetableBox::Api::Order).to receive(:new).and_return(order_api)
      specific_date = Date.new(2024, 1, 1)
      expect(order_api).to receive(:list).with(session.urls.order_list_url, specific_date)
      session.order_list(specific_date)
    end
  end

  describe '#current_order' do
    it 'retrieves the current order details' do
      order_api = instance_double(VegetableBox::Api::Order)
      allow(VegetableBox::Api::Order).to receive(:new).and_return(order_api)
      order_id = 123
      expect(order_api).to receive(:current_order).with(
        session.urls.order_details_url,
        session.urls.order_list_url,
        order_id
      )
      session.current_order(order_id)
    end
  end

  describe '#notify_current_order' do
    it 'sends notification for the current order' do
      order_api = instance_double(VegetableBox::Api::Order)
      notifier = instance_double(VegetableBox::Notifiers::TrelloEmail)
      allow(VegetableBox::Api::Order).to receive(:new).and_return(order_api)
      allow(VegetableBox::Notifiers::TrelloEmail).to receive(:new).and_return(notifier)

      order_data = [{ name: 'Carrot', amount: 2, unit: 'kg', net_price: 3.5 }]
      expect(order_api).to receive(:current_order).with(
        session.urls.order_details_url,
        session.urls.order_list_url,
        nil
      ).and_return(order_data)
      expect(notifier).to receive(:send_current_order).with(order_data)

      session.notify_current_order
    end
  end
end
