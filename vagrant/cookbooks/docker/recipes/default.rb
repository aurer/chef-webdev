# Ensure docker is installed
package [
	"docker",
	"docker-compose"
]

# Start docker service
service 'docker' do
  action :start
end
