# VegetableBox

[![CI for Vegetable Box](https://github.com/y0wel/vegetable_box/actions/workflows/main.yml/badge.svg)](https://github.com/y0wel/vegetable_box/actions/workflows/main.yml)  

**VegetableBox** is a Ruby gem for interacting with the online order system at **diegemuesekiste.de**.

It helps you to:

- fetch available order lists
- fetch the current order with normalized item data
- and send the current order to a Trello inbox email (via SMTP)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vegetable_box'
```

Then run:

```sh
bundle install
```

Or install directly:

```sh
gem install vegetable_box
```

## Usage

### 1) Configure the gem

You can configure globally:

```ruby
require 'vegetable_box'

VegetableBox.configure do |config|
  config.username = ENV['VEGETABLE_BOX_USERNAME']
  config.password = ENV['VEGETABLE_BOX_PASSWORD']
  config.base_url = 'https://www.diegemuesekiste.de' # optional (default is set)

  # Optional: specific delivery date (Date, Time, or String parseable by Date.parse)
  # config.delivery_date = '2026-01-23'

  # Optional: needed for notify_current_order
  config.smtp = {
    address: 'smtp.example.com',
    port: 587,
    domain: 'example.com',
    user_name: 'smtp_user@example.com',
    password: 'smtp_password',
    authentication: :login,
    enable_starttls_auto: true
  }
  config.trello_inbox_mail = 'your-trello-inbox@example.com'
end
```

Or instantiate a dedicated configuration object:

```ruby
config = VegetableBox::Configuration.new(
  username: ENV['VEGETABLE_BOX_USERNAME'],
  password: ENV['VEGETABLE_BOX_PASSWORD'],
  smtp: {
    address: 'smtp.example.com',
    port: 587,
    domain: 'example.com',
    user_name: 'smtp_user@example.com',
    password: 'smtp_password',
    authentication: :login,
    enable_starttls_auto: true
  },
  trello_inbox_mail: 'your-trello-inbox@example.com'
)
```

### 2) Create a client and interact with orders

```ruby
client = VegetableBox::Client.new(VegetableBox.config)
# or: client = VegetableBox::Client.new(config)

client.login

# Get all orders for the configured/current delivery date
orders = client.order_list(for_specific_date: true)

# Get current order (order_id optional)
current_order = client.current_order
# or: current_order = client.current_order(order_id: 123)

# Send current order to Trello inbox email
client.notify_current_order
```

### Notes

- Calling `logout`, `order_list`, `current_order`, or `notify_current_order` without logging in raises `VegetableBox::Error::NotLoggedInError`.
- `delivery_date` is normalized to `YYYY-MM-DD`. If invalid or missing, the gem falls back to the next Saturday.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/y0wel/vegetable_box.

1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Run checks locally:
   ```sh
   bin/setup
   bundle exec rake
   ```
5. Open a pull request

Please keep changes focused, documented, and covered by specs.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VegetableBox project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/y0wel/vegetable_box/blob/master/CODE_OF_CONDUCT.md).
