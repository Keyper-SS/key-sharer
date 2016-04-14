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

 namespace :generate do
  desc 'Generate a timestamped, empty Sequel migration.'
  task :migration, :name do |_, args|
    if args[:name].nil?
      puts 'You must specify a migration name (e.g. rake generate:migration[create_events])!'
      exit false
    end

    content = "Sequel.migration do\n  up do\n    \n  end\n\n  down do\n    \n  end\nend\n"
    timestamp = Time.now.to_i
    filename = File.join(File.dirname(__FILE__), 'migrations', "#{timestamp}_#{args[:name]}.rb")

    File.open(filename, 'w') do |f|
      f.puts content
    end

    puts "Created the migration #{filename}"
  end
end
 
 desc 'Run all the tests'
 Rake::TestTask.new(name=:spec) do |t|
   t.pattern = 'specs/*_spec.rb'
 end