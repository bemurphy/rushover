require File.expand_path("../test_helper", __FILE__)

class RushoverClientTest < RushoverTest
  def client
    Rushover::Client.new("test_api_token")
  end

  test "it initializes with a token" do
    subject = Rushover::Client.new("foobar")
    assert_equal "foobar", subject.token
  end

  context "with mandatory params" do
    setup do
      client.notify("test_user", "test message")
    end

    test "sending a message hits the messages.json endpoint" do
      assert_equal "/1/messages.json", FakeWeb.last_request.path
    end

    test "sending a message uses the token" do
      assert_equal "test_api_token", last_request_json["token"]
    end

    test "sending a message to the intended user" do
      assert_equal "test_user", last_request_json["user"]
    end

    test "sending a notification includes the message" do
      assert_equal "test message", last_request_json["message"]
    end

    test "successful notify" do
      resp = client.notify("test_user", "test message")
      assert_equal({"status" => 1}, resp)
    end

    test "failed notify" do
      FakeWeb.register_uri(:post, "https://api.pushover.net/1/messages.json",
                           :body => { "message" => "cannot be blank", "status" => 0 }.to_json,
                           :content_type => "application/json", :status => ["400", "Bad request"])
      resp = client.notify("test_user", nil)
      assert_equal 0, resp["status"]
      assert_equal "cannot be blank", resp["message"]
    end
  end

  context "with optional params" do
    test "basic optional params" do
      client.notify("test_user", "test message", :device => "test device", :title => "test title", :priority => 1, :timestamp => 123123)
      assert_equal "test device", last_request_json["device"]
      assert_equal "test title", last_request_json["title"]
      assert_equal "1", last_request_json["priority"].to_s
      assert_equal "123123", last_request_json["timestamp"].to_s
    end
  end
end
