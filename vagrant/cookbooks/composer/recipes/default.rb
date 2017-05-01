# Install Composer
execute "composer-install" do
  command "curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer"
  creates "/usr/local/bin/composer"
  environment "PATH" => "/usr/bin:/usr/sbin"
end
