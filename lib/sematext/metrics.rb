# Copyright 2013 Sematext Group, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "sematext/metrics/version"
require "sematext/metrics/serializer"
require "sematext/metrics/settings"
require "sematext/metrics/validator"
require "sematext/metrics/sync_sender"
require "sematext/metrics/async_sender"

module Sematext
  module Metrics
    def self.initialize(token, args = {})
      raise "Token should be defined" unless token

      opts = { :async => false }
      if !!args == args
        opts[:async] = args
      elsif args.kind_of?(Hash)
        opts.merge!(args)
      end
      @client = opts[:async] ? Client.async(token, opts[:receiver_url]) : Client.sync(token, opts[:receiver_url])
    end

    def self.send datapoint
      client.send datapoint
    end
    
    def self.send_batch datapoints
      client.send_batch datapoints
    end

    private
    def self.client
      raise "Client should be initialized (forgot to call Sematext::Metrics.initialize?)" unless @client
      @client
    end

    class Client
      class << self
        def sync(token, receiver_url = nil)
          url, path = parse_url(receiver_url) if receiver_url
          Client.new(SyncSender.new(token, url, path))
        end
        
        def async(token, receiver_url = nil)
          url, path = parse_url(receiver_url) if receiver_url
          Client.new(AsyncSender.new(token, url, path))
        end

        private
        def parse_url(url)
          uri = URI.parse(url)
          ["#{uri.scheme}://#{uri.host}:#{uri.port}", uri.path]
        end
      end

      def initialize(sender)
        @sender = sender
        @serializer = RawSerializer.new
        @validator = RawValidator.new
      end
      
      def send datapoint
        return nil if datapoint.nil?

        result = send_batch [datapoint]
        result.first
      end

      def send_batch datapoints
        return nil if datapoints.empty?

        datapoints.each do |dp| 
          @validator.validate(dp)
          dp[:timestamp] = epoch unless dp[:timestamp]
        end

        datapoints.each_slice(Settings::MAX_DP_PER_REQUEST).map do |slice|
          serialized = @serializer.serialize_datapoints(slice)
          @sender.send serialized
        end
      end
      
      def epoch 
        Time.now.to_i * 1000
      end
    end
  end
end
