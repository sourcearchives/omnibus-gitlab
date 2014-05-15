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

database_clients = %w{unicorn sidekiq}

database_clients.each do |client|
  execute "gitlab-ctl stop #{client}" do
    notifies :run, "execute[gitlab-ctl start #{client}]"
    only_if { OmnibusHelper.should_notify?(client) }
  end
end

file "/opt/gitlab/embedded/service/gitlab-rails/db/schema.rb" do
  owner node['gitlab']['user']['username']
end
execute "gitlab-rake db:migrate"

execute "gitlab-rake cache:clear"

database_clients.each do |client|
  execute "gitlab-ctl start #{client}" do
    action :nothing
  end
end
