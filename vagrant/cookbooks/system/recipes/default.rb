#
# Cookbook:: system
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
package [
	"epel-release",
	"vim-enhanced",
	"git",
	"wget",
	"telnet",
	"tree",
	"htop"
]

# Customise prompt and tings
['prompt.sh', 'aliases.sh'].each do |file|
	cookbook_file "/etc/profile.d/#{file}" do
		source file
		owner 'root'
		group 'root'
		mode 0644
	end
end

# Root vimrc
cookbook_file '/root/.vimrc' do
	source 'vimrc'
	owner 'root'
	group 'root'
	mode 0644
end

# Vagrant vimrc
cookbook_file '/home/vagrant/.vimrc' do
	source 'vimrc'
	owner 'vagrant'
	group 'vagrant'
	mode 0644
end