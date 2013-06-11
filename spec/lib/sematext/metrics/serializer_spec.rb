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

describe Sematext::Metrics::RawSerializer do
  let(:ser) { Sematext::Metrics::RawSerializer.new }

  it "serializes datapoint to raw format" do
    ser = Sematext::Metrics::RawSerializer.new
    expect(ser.serialize_datapoint({
      :timestamp => 1370888200668,
      :name => 'coffee_consumed',
      :value => 42,
      :agg_type => :sum,
      :filter1 => 'building-1',
      :filter2 => 'kitchen-1'
    })).to eq("1370888200668\tcoffee_consumed\t42\tsum\tbuilding-1\tkitchen-1")
    
    expect(ser.serialize_datapoint({
      :timestamp => 1370888200668,
      :name => 'coffee_consumed',
      :value => 42,
      :agg_type => :sum,
      :filter2 => 'kitchen-1'
    })).to eq("1370888200668\tcoffee_consumed\t42\tsum\t\tkitchen-1")

    expect(ser.serialize_datapoint({})).to eq("\t\t\t\t\t")
  end
  
  it "serializes datapoints to raw format" do
    ser = Sematext::Metrics::RawSerializer.new
    dp1 = {
      :timestamp => 1370889515001, 
      :name => 'unicorns_found',
      :value => 101,
      :agg_type => :sum,
      :filter1 => 'Missouri',
      :filter2 => 'Springfield'
    }
    dp2 = {
      :timestamp => 1370889515001,
      :name => 'uptime',
      :value => 36,
      :agg_type => :max,
      :filter1 => 'rack-1',
      :filter2 => 'host-1'
    }

    expect(ser.serialize_datapoints([dp1, dp2])).to eq(
     "1370889515001\tunicorns_found\t101\tsum\tMissouri\tSpringfield\n"+
     "1370889515001\tuptime\t36\tmax\track-1\thost-1"
    )
  end
end
