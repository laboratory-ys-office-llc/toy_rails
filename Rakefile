# Rakefile

require 'active_record'
require 'rake'
require_relative 'app.rb'

namespace :db do
  task :load_config do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: 'db/infinite_insight_engine.sqlite3'
    )
  end

  desc 'Create a new migration file'
  task :create_migration, [:name] => :load_config do |_, args|
    name = args.name
    unless name
      puts 'Usage: rake db:create_migration[name]'
      exit 1
    end
    timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
    filename = "#{timestamp}_#{name}.rb"
    filepath = File.join('db/migrate', filename)
    open(filepath, 'w') do |file|
      file.puts "class #{name.camelize} < ActiveRecord::Migration[7.0]"
      file.puts '  def change'
      file.puts '    # add migration content here'
      file.puts '  end'
      file.puts 'end'
    end
    puts "Created migration #{filepath}"
  end

  desc 'Migrate the database'
  task migrate: :load_config do
    migration_dir = File.join(File.dirname(__FILE__), 'db/migrate')
    migration_context = ActiveRecord::MigrationContext.new(migration_dir, ActiveRecord::SchemaMigration)
    migration_context.migrate
  end
end
