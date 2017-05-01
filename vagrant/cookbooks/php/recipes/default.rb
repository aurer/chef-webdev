# Install Composer
execute "Install webtatic" do
	command "rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm"
	not_if "rpm -qa | grep webtatic"
end

# Add PHP packages
package [
  'php71w-fpm',
  'php71w-gd',
  'php71w-mcrypt',
  'php71w-mbstring',
  'php71w-mysqlnd',
  'php71w-pdo',
  'php71w-pear',
  'php71w-xml',
  'php71w-cli'
]

# Ensure composer is installed
package 'composer'

# Use custom config
cookbook_file '/etc/php-fpm.d/www.conf' do
  source 'www.conf'
  owner 'root'
  group 'root'
  mode 0644
end

# Start php-fpm service
service 'php-fpm' do
  action :start
end
