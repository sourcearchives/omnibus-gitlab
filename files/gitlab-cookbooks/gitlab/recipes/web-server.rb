#
# Copyright:: Copyright (c) 2014 GitLab B.V.
# License:: Apache License, Version 2.0
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
#

webserver_username = node['gitlab']['web-server']['username']
webserver_group = node['gitlab']['web-server']['group']

# Create the group for the GitLab user
group webserver_group do
  gid node['gitlab']['web-server']['gid']
end

# Create the webserver user
user webserver_username do
  shell node['gitlab']['web-server']['shell']
  uid node['gitlab']['web-server']['uid']
  gid webserver_group
  supports manage_home: false
end
