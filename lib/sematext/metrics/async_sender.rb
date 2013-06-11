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

module Sematext
  module Metrics
    class AsyncSender
      def initialize(token)
        @token = token
        if defined?(EventMachine)
          require 'em-http-request'
        end
      end
      
      def send data
        deferrable = EventMachine::DefaultDeferrable.new

        post_options = {
          :path => Settings::RECEIVER_PATH,
          :query => {:token => @token},
          :body => data,
          :head => {
            'Content-Type' => 'text/plain',
            'User-Agent' => Settings::USER_AGENT
          }
        }
        
        http = EventMachine::HttpRequest.new(Settings::RECEIVER_URI).post post_options
        http.errback { 
          deferrable.fail{{:status => :failed}}
        }
        http.callback {
          if http.response_header.status == 201 then
            deferrable.succeed({:status => :succeed})
          else
            deferrable.fail({:status => :failed, :response => http.response})
          end
        }
        deferrable
      end
    end
  end
end
