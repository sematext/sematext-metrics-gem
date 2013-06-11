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
    class RawSerializer
      def serialize_datapoints datapoint
        datapoint.map{|m| self.serialize_datapoint(m)}.join("\n")
      end
      
      def serialize_datapoint datapoint
        format = [
          datapoint[:timestamp], 
          datapoint[:name], 
          datapoint[:value], 
          datapoint[:agg_type], 
          datapoint[:filter1], 
          datapoint[:filter2]
        ]
        format.join("\t")
      end
    end
  end
end
