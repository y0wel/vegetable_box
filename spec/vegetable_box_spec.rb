# frozen_string_literal: true

RSpec.describe VegetableBox do
  it 'has a version number' do
    expect(VegetableBox::VERSION).not_to be nil
  end

  it 'is a module carrying a configuration' do
    expect(described_class.config).to be_a(VegetableBox::Configuration)
  end

  it 'is a module that can yield the config for initializers to be changed' do
    tmp_value = described_class.config.username

    expect do
      described_class.configure do |_config|
        described_class.config.username = 'new_user'
      end
    end.to change { described_class.config.username }.from(tmp_value).to('new_user')
  ensure
    described_class.config.username = tmp_value
  end
end
