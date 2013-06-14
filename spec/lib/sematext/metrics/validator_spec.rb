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
  let(:validator) { Sematext::Metrics::RawValidator.new }
  
  it "raises exception when name is not set or empty" do 
    expect {
      validator.validate(
        :name => '',
        :agg_type => :sum,
        :value => 42
      )
    }.to raise_error

    expect {
      validator.validate(
        :agg_type => :sum,
        :value => 42
      )
    }.to raise_error
  end
  
  it "raises exception when value is not set" do
    expect {
      validator.validate(
        :name => 'name',
        :agg_type => :sum
      )
    }.to raise_error
  end

  it "raises exceptionw when agg_type is not set or invalid" do
    expect {
      validator.validate(
        :name => 'name',
        :value => 42
      )
    }.to raise_error
    expect {
      validator.validate(
        :name => 'name',
        :value => 42,
        :agg_type => :invalid
      )
    }.to raise_error
  end

  it "raises exception when name, filter1 or filter2 too log" do
    expect {
      validator.validate(
        :name => 'a' * 256,
        :agg_type => :sum,
        :value => 42
      )
    }.to raise_error
    expect {
      validator.validate(
        :name => 'name',
        :agg_type => :sum,        
        :value => 42,
        :filter1 => 'a' * 256
      )
    }.to raise_error
    expect {
      validator.validate(
        :name => 'name',
        :agg_type => :sum,        
        :value => 42,
        :filter2 => 'a' * 256
      )
    }.to raise_error
  end
  
  it "raises exception when value is not a number" do
    expect {
      validator.validate(
        :name => 'name',
        :agg_type => :sum,        
        :value => 'foo'
      )
    }.to raise_error
    expect {
      validator.validate(
        :name => 'name',
        :agg_type => :sum,
        :value => 100.2
      )
    }.to_not raise_error
    expect {
      validator.validate(
        :name => 'name',
        :agg_type => :sum,
        :value => 100
      )
    }.to_not raise_error
  end
end
