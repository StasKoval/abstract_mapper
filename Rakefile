# encoding: utf-8

require "rubygems"
require "bundler/setup"

# Loads bundler tasks
Bundler::GemHelper.install_tasks

# Loads the Hexx::RSpec and its tasks
begin
  require "hexx-suit"
  Hexx::Suit.install_tasks
rescue LoadError
  require "hexx-rspec"
  Hexx::RSpec.install_tasks
end

desc "Sets the Hexx::RSpec :test task to default"
task :default do
  system "bundle exec rake test:coverage:run"
end

desc "Runs mutation metric before the first evil being kept"
task :exhort do
  system "mutant -r ./spec/spec_helper --use rspec AbstractMapper* --fail-fast"
end

desc "Runs mutation metric to view all evils"
task :mutant do
  system "mutant -r ./spec/spec_helper --use rspec AbstractMapper*"
end
