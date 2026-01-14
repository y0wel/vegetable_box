# frozen_string_literal: true

RSpec.describe VegetableBox::Client do
  subject(:client) { described_class.new(config) }

  let(:config) do
    VegetableBox::Configuration.new(
      username: 'test_user',
      password: 'test_password',
      smtp: {
        address: 'smtp.example.com',
        port: 587,
        domain: 'example.com',
        user_name: 'smtp_user',
        password: 'smtp_password',
        authentication: :login,
        enable_starttls_auto: true
      },
      trello_inbox_mail: 'trello@example.com'
    )
  end

  let(:session) do
    double('VegetableBox::Session')
  end

  shared_examples 'requires login' do |method_name, *args|
    context 'when not logged in' do
      it 'raises NotLoggedInError' do
        allow(VegetableBox::Session).to receive(:new).with(config).and_return(session)
        expect(session).to receive(:logged_in?).and_return(false)
        expect do
          client.public_send(method_name, *args)
        end.to raise_error(VegetableBox::Error::NotLoggedInError)
      end
    end
  end

  describe '#login' do
    it 'logs in successfully' do
      allow(VegetableBox::Session).to receive(:new).with(config).and_return(session)
      expect(session).to receive(:login)
      client.login
    end
  end

  describe '#logout' do
    it 'logs out successfully' do
      allow(VegetableBox::Session).to receive(:new).with(config).and_return(session)
      expect(session).to receive(:logged_in?).and_return(true)
      expect(session).to receive(:logout)
      client.logout
    end

    it_behaves_like 'requires login', :logout
  end

  describe '#order_list' do
    it 'retrieves the order list successfully' do
      allow(VegetableBox::Session).to receive(:new).with(config).and_return(session)
      expect(session).to receive(:logged_in?).and_return(true)
      expect(session).to receive(:order_list).with(true)
      client.order_list(for_specific_date: true)
    end

    it_behaves_like 'requires login', :order_list
  end

  describe '#current_order' do
    it 'retrieves the current order successfully' do
      allow(VegetableBox::Session).to receive(:new).with(config).and_return(session)
      expect(session).to receive(:logged_in?).and_return(true)
      expect(session).to receive(:current_order).with(123)
      client.current_order(order_id: 123)
    end

    it_behaves_like 'requires login', :current_order
  end

  describe '#notify_current_order' do
    it 'sends notification for the current order successfully' do
      allow(VegetableBox::Session).to receive(:new).with(config).and_return(session)
      expect(session).to receive(:logged_in?).and_return(true)
      expect(session).to receive(:notify_current_order)
      client.notify_current_order
    end

    it_behaves_like 'requires login', :notify_current_order
  end
end
