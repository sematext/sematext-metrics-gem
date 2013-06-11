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
    module Settings
      USER_AGENT = "Sematext-metrics-ruby #{VERSION}"
      RECEIVER_URI = "http://spm-receiver.sematext.com"
      RECEIVER_PATH = "/receiver/custom/receive.raw"
      MAX_DP_PER_REQUEST = 100
    end
  end
end
