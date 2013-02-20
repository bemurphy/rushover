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
      assert_equal "test_api_token", last_request_param("token")
    end

    test "sending a message to the intended user" do
      assert_equal "test_user", last_request_param("user")
    end

    test "sending a notification includes the message" do
      assert_equal "test message", last_request_param("message")
    end

    test "successful notify" do
      resp = client.notify("test_user", "test message")
      assert_equal 1, resp["status"]
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
      client.notify("test_user", "test message", :device => "test device",
                    :title => "test title", :priority => 1, :timestamp => 123123)
      assert_equal "test device", last_request_param("device")
      assert_equal "test title", last_request_param("title")
      assert_equal "1", last_request_param("priority").to_s
      assert_equal "123123", last_request_param("timestamp").to_s
    end
  end

  context "looking up receipt data" do
    test "when the receipt exists" do
      FakeWeb.register_uri(:get, "https://api.pushover.net/1/receipts/123asdf.json?token=test_api_token",
                           :body => {"status"=>1, "acknowledged"=>1, "acknowledged_at"=>1361314981,
                                     "last_delivered_at"=>1361314753, "expired"=>1,
                                     "expires_at"=>1361314783, "called_back"=>0,
                                     "called_back_at"=>0,
                                     "request"=>"9a38ad590235bc07ea7ae2b5fd83f99f"}.to_json,
                           :content_type => "application/json")

      resp = client.receipt("123asdf")
      assert_equal 1, resp[:expired]
      assert_equal 1, resp[:acknowledged]
      assert_equal 1361314981, resp[:acknowledged_at]
      assert_equal "9a38ad590235bc07ea7ae2b5fd83f99f", resp[:request]
    end
  end

  context "user validation" do
    test "determining a user exists" do
      FakeWeb.register_uri(:post, "https://api.pushover.net/1/users/validate.json",
                           :body => { "status" => 1 }.to_json,
                           :content_type => "application/json")
      resp = client.validate("user_exists")
      assert_equal "user_exists", last_request_param("user")
      assert resp.ok?
    end

    test "determining a user device exists" do
      FakeWeb.register_uri(:post, "https://api.pushover.net/1/users/validate.json",
                           :body => { "status" => 1 }.to_json,
                           :content_type => "application/json")
      resp = client.validate("user_exists", "htc4g")
      assert_equal "htc4g", last_request_param("device")
    end

    test "determining a user does not exist" do
      FakeWeb.register_uri(:post, "https://api.pushover.net/1/users/validate.json",
                           :body => { "status" => 0 }.to_json,
                           :content_type => "application/json")
      resp = client.validate("user_missing")
      assert_equal "user_missing", last_request_param("user")
      refute resp.ok?
    end

    test "validate! calls ok?" do
      assert client.validate!("user_exists")
    end
  end
end
