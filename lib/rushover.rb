require "rushover/version"
require "rest-client"
require "json"

module Rushover
  class Client
    MESSAGES_ENDPOINT = "https://api.pushover.net/1/messages.json".freeze

    attr_accessor :token

    def initialize(token)
      @token = token
    end

    def notify(user_key, message, options = {})
      data = { :token => token, :user => user_key, :message => message }
      data.merge!(options)
      begin
        resp = RestClient.post MESSAGES_ENDPOINT, data.to_json, :content_type => "application/json"
        JSON.parse(resp)
      rescue RestClient::Exception => e
        JSON.parse(e.response)
      end
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
end
