require File.expand_path("../test_helper", __FILE__)

class RushoverResponseTest < RushoverTest
  def data
    @data ||= { "status" => 1 }
  end

  test "initializing with a response data" do
    response = Rushover::Response.new(data)
    assert_equal data, response.data
  end

  test "delegates [] lookups to the response hash" do
    data = { "status" => 1, "foo" => "bar" }
    response = Rushover::Response.new(data)
    assert_equal 1, response["status"]
    assert_equal "bar", response[:foo]
  end

  test "checking if ok?" do
    response = Rushover::Response.new(data)
    assert response.ok?
    response.data = { "status" => 0 }
    refute response.ok?
  end

  test "inspect delegates to the data" do
    response = Rushover::Response.new(data)
    assert_equal data.inspect, response.inspect
  end

  test "to_s delegates to the data" do
    response = Rushover::Response.new(data)
    assert_equal data.to_s, response.to_s
  end

  test "to_h returns the data" do
    response = Rushover::Response.new(data)
    assert_equal data, response.to_h
  end
end
