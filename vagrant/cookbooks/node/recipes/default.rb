# Ensure node is installed
package [
	'nodejs',
	'npm'
]

# Install Yarn repo
execute 'Install Yarn repo' do
	command 'sudo wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo'
	creates '/etc/yum.repos.d/yarn.repo'
end

# Ensure Yarn is installed
package 'yarn'
