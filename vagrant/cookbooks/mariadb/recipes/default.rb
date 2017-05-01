# Ensure mmariadb is installed
package [
	'mariadb',
	'mariadb-server'
]

# Start mariadb service
service 'mariadb' do
	action :start
end
