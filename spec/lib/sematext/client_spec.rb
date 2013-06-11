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

require "spec_helper"

describe Sematext::Metrics::Client do
  let(:sender) { double("sender") }
  let(:client) { Sematext::Metrics::Client.new(sender) }
  
  it "sends serialized datapoints using sender" do
    sender.should_receive(:send).with("123\tdp-1\t43\tsum\t\t")
    client.send :timestamp => 123, :name => 'dp-1', :value => 43, :agg_type => :sum
  end

  it "sends large datapoints list by chunks" do
    datapoints = [{:name => 'dp-1', :value => 43, :agg_type => :sum}] * 102

    sender.should_receive(:send) do |value| 
      expect(value.split("\n")).to have(100).items
    end
    
    sender.should_receive(:send) do |value| 
      expect(value.split("\n")).to have(2).items
    end

    client.send_batch datapoints
  end
end
