# Ensure docker is installed
package "docker"

# Ensure docker-compose is installed
execute "Install docker-compose" do
	command "curl -L https://github.com/docker/compose/releases/download/1.13.0-rc1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose"
	creates "/usr/local/bin/docker-compose"
end

# Start php-fpm service
service 'docker' do
  action :start
end
