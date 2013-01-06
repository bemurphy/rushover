require "rushover/version"
require "rest-client"
require "json"

module Rushover
  class Client
    BASE_URL = "https://api.pushover.net/1".freeze
    MESSAGES_ENDPOINT = "#{BASE_URL}/messages.json".freeze
    VALIDATE_ENDPOINT = "#{BASE_URL}/users/validate.json".freeze

    attr_accessor :token

    def initialize(token)
      @token = token
    end

    def notify(user_key, message, options = {})
      data = { :token => token, :user => user_key, :message => message }
      data.merge!(options)
      post_json(MESSAGES_ENDPOINT, data)
    end

    def validate(user_key, device = nil)
      data = { :token => token, :user => user_key }
      data[:device] = device if device
      post_json(VALIDATE_ENDPOINT, data)
    end

    def validate!(user_key, device = nil)
      validate(user_key, device).ok?
    end

    private

    def post_json(url, data)
      raw_response = begin
        RestClient.post url, data
      rescue RestClient::Exception => e
        e.response
      end

      Response.new JSON.parse(raw_response)
    end
  end

  class User
    attr_accessor :key, :client

    def initialize(key, client)
      @key = key
      @client = client
    end

    def notify(message, options = {})
      client.notify(key, message, options)
    end

    def validate(device = nil)
      client.validate(key, device)
    end

    def validate!(device = nil)
      validate(device).ok?
    end
  end

  class Response
    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def [](key)
      @data[key.to_s]
    end

    def ok?
      self["status"].to_i == 1
    end

    def inspect
      @data.inspect
    end

    def to_s
      @data.to_s
    end

    def to_h
      @data.dup
    end
  end
end
