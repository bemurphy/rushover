require File.expand_path("../test_helper", __FILE__)

class RushoverUserTest < RushoverTest
  def client
    Rushover::Client.new("test_api_token")
  end

  setup do
    @user = Rushover::User.new("user_key", client)
  end

  test "it initializes with a user key and client" do
    assert_equal "user_key", @user.key
    assert @user.client
  end

  test "notifying the user via the client" do
    @user.notify("test user message", :priority => 1)
    assert_equal "test user message", last_request_param("message")
    assert_equal "1", last_request_param("priority").to_s
  end

  test "validate if user exists" do
    resp = @user.validate
    assert_equal "user_key", last_request_param("user")
    assert resp.ok?
  end

  test "validate if user device exists" do
    @user.validate("htc4g")
    assert_equal "htc4g", last_request_param("device")
  end

  test "validate! calls ok?" do
    assert @user.validate!
  end
end
