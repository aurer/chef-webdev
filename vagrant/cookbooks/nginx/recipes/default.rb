# Ensure nginx is installed
package "nginx"

# Use a custom config file
cookbook_file '/etc/nginx/nginx.conf' do
	source 'nginx.conf'
	owner 'root'
	group 'root'
	mode 0644
end

# Install nginx includes
execute 'Install nginx includes' do
	command 'git clone https://github.com/aurer/nginx-conf.git /etc/nginx/includes'
	creates '/etc/nginx/includes'
end

# Start the nginx service
service 'nginx' do
	action :start
end
