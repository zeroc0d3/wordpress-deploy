server '192.168.2.2', user: 'deploy', roles: %w{app web}

set :branch, "staging"

set :ssh_options, {
  forward_agent: true
}

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

