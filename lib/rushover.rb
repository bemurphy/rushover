require "rushover/version"
require "rest-client"
require "json"

module Rushover
  class Client
    MESSAGES_ENDPOINT = "https://api.pushover.net/1/messages.json".freeze
    VALIDATE_ENDPOINT = "https://api.pushover.net/1/users/validate.json".freeze

    attr_accessor :token

    def initialize(token)
      @token = token
    end

    def notify(user_key, message, options = {})
      data = { :token => token, :user => user_key, :message => message }
      data.merge!(options)

      raw_response = begin
        RestClient.post MESSAGES_ENDPOINT, data.to_json, :content_type => "application/json"
      rescue RestClient::Exception => e
        e.response
      end

      Response.new JSON.parse(raw_response)
    end

    def validate(user_key, device = nil)
      data = { :token => token, :user => user_key }
      data[:device] = device if device

      raw_response = begin
        RestClient.post VALIDATE_ENDPOINT, data.to_json, :content_type => "application/json"
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
