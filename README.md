# Rushover

A simple ruby [Pushover](https://pushover.net/) client.  Pushover allows
sending simple push notifications to clients on iOS and Android devices.

## Installation

Add this line to your application's Gemfile:

    gem 'rushover'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rushover

## Usage

```ruby
require "rushover"

client = Rushover::Client.new(your_app_token)
client.notify(user_key, "some message", :priority => 1, :title => "a title!")

# Also provides a User class for convenience.  Just keeps the user key
# around if you want to deal with a User object
user = Rushover::User.new(user_key, rushover_client)
user.notify("some user message", :title => "another title")
```

Optional params to the Pushover like `priority` or `title` are passed through.

Calls to `#notify` will return the parsed JSON response body.  Pushover app uses
:status => 1 for success, 0 for failures.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
