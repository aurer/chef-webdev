# Ensure mmariadb is installed
package [
	'postgresql',
	'postgresql-server',
	'postgresql-contrib'
]

# Start mariadb service
service 'postgresql' do
	action :start
end
