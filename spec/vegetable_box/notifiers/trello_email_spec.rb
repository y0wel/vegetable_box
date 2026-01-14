# frozen_string_literal: true

require 'spec_helper'

RSpec.describe VegetableBox::Notifiers::TrelloEmail do
  subject(:notifier) { described_class.new(config) }

  let(:smtp_settings) do
    {
      address: 'smtp.web.de',
      port: 587,
      user_name: 'user@example.com',
      password: 'password',
      authentication: :login,
      enable_starttls_auto: true
    }
  end

  let(:config) do
    double(
      'Config',
      smtp: smtp_settings,
      trello_inbox_mail: 'trello@example.com'
    )
  end

  let(:order) do
    [
      {
        delivery_date: '2025-12-20',
        name: 'Carrot',
        amount: 2,
        unit: 'kg',
        net_price: 3.5
      }
    ]
  end

  before do
    allow(VegetableBox::Helpers::FormattingHelper).to receive(:format_order).and_return('formatted order')
    allow(Mail).to receive(:defaults)
    allow_any_instance_of(Mail::Message).to receive(:deliver!).and_return(true)
  end

  it 'sends an email with the correct parameters' do
    mail_double = instance_double(Mail::Message)
    expect(Mail).to receive(:new).and_return(mail_double)
    expect(mail_double).to receive(:from=).with(smtp_settings[:user_name])
    expect(mail_double).to receive(:to=).with(config.trello_inbox_mail)
    expect(mail_double).to receive(:subject=).with("🥕 Vegetable Box Order for #{order.first[:delivery_date]}")
    expect(mail_double).to receive(:body=).with('formatted order')
    expect(mail_double).to receive(:content_type=).with('text/plain; charset=UTF-8')
    expect(mail_double).to receive(:deliver!)

    notifier.send_current_order(order)
  end
end
