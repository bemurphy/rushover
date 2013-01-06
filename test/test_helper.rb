require "test/unit"
require "contest"
require "fakeweb"
require "rushover"

FakeWeb.allow_net_connect = false

class RushoverTest < Test::Unit::TestCase
  setup do
    FakeWeb.register_uri(:post, "https://api.pushover.net/1/messages.json",
                         :body => { :status => 1 }.to_json,
                         :content_type => "application/json")

    FakeWeb.register_uri(:post, "https://api.pushover.net/1/users/validate.json",
                         :body => { "status" => 1 }.to_json,
                         :content_type => "application/json")
  end

  teardown do
    FakeWeb.clean_registry
  end

  def last_request_param(param)
    params = CGI.parse(FakeWeb.last_request.body)
    Array(params[param]).first
  end
end
