# Install nginx includes
execute 'Install nginx includes' do
	command 'rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch'
end

# Use a custom config file
cookbook_file '/etc/yum.repos.d/elastic.repo' do
	source 'elastic.repo'
	owner 'root'
	group 'root'
	mode 0644
end

# Ensure nginx is installed
package [
	'filebeat',
	'logstash',
	'elasticsearch'
]
