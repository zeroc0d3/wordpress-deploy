server '192.168.1.1', user: 'deploy', roles: %w{app web}

set :branch, "production"

set :ssh_options, {
  forward_agent: true
}

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

