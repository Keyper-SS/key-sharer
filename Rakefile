require 'rake/testtask'
require './app'

task :default => [:spec]

namespace :db do
  require 'sequel'
  Sequel.extension :migration

  desc 'Run migrations'
  task :migrate do
    puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
    puts 'Migrating to latest'
    Sequel::Migrator.run(DB, 'db/migrations')
  end

  desc 'Perform migration reset (full rollback and migration)'
  task :reset do
    Sequel::Migrator.run(DB, 'db/migrations', target: 0)
    Sequel::Migrator.run(DB, 'db/migrations')
  end
end

desc 'Run all the tests'
Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'specs/*_spec.rb'
end

namespace :key do
  require 'rbnacl/libsodium'
  require 'base64'

  desc 'Create rbnacl key'
  task :generate do
    key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
    puts "KEY: #{Base64.strict_encode64 key}"
  end

  desc 'Create rbnacl key and create file'
  task :generate_file do
    key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
    puts "KEY: #{Base64.strict_encode64 key}"
    content = 
    "# Copy this file to [app]/config/config_env.rb\n# Replace [*] with credentials/keys/etc.\n# New keys can be generated by `rake key:generate` task
    config_env :development, :test do
      set 'DB_KEY', '#{Base64.strict_encode64 key}'
    end"
    filename = File.join(File.dirname(__FILE__), 'config', "config_env.rb")

    File.open(filename, 'w') do |f|
      f.puts content
    end
  end
end
