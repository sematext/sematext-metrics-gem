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

describe Sematext::Metrics::RawValidator do
  let(:validator) { Sematext::Metrics::RawValidator }

  it "raises exception when datapoint is invalid" do
    expect {
      validator.validate(
        :timestamp => 123,
        :name => 'coffee_consumed',
        :value => 1234,
        :agg_type => :unknown
      )
    }.to raise_error
    
    expect {
      validator.validate(
        :name => 'n' * 256,
        :agg_type => :sum,
        :filter1 => 'filter',
      )
    }.to raise_error
  end
end
