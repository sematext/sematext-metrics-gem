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
    class RawValidator
      MAX_STRING_LENGTH = 255
      VALID_AGG_TYPES = %w(sum avg min max)
      
      def check_bounds name, value
        raise "'#{name}' value can't be longer than 255 characters" unless value.size <= 255
      end

      def check_obligatory name, value
        raise "'#{name}' should be defined" unless value
      end
      
      def validate datapoint
        [:name, :value, :agg_type].each do |field|
          check_obligatory field, datapoint[field]
        end
        raise "name can't be empty" if datapoint[:name].empty?
        raise "value should be a number" unless datapoint[:value].kind_of?(Numeric)
        [:name, :filter1, :filter2].each do |field|
          value = datapoint[field]
          check_bounds field, datapoint[field] if value
        end
        unless VALID_AGG_TYPES.include? datapoint[:agg_type].to_s
          raise "Invalid aggregation type, valid values are: #{VALID_AGG_TYPES.join(', ')}"
        end
      end
    end
  end
end
