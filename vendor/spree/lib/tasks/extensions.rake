require 'rake/testtask'
require 'spree/extension'
require 'custom_fixtures'

namespace :db do
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x. Turn off output with VERBOSE=false."
  task :migrate => :environment do
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    # spree 
    ActiveRecord::Migrator.migrate("#{SPREE_ROOT}/db/migrate/", version)
    # core extensions
    Spree::Extension.descendants.select{|ext| ext.root.starts_with?(SPREE_ROOT)}.each do |extension|
      ActiveRecord::Migrator.migrate("#{extension.root}/db/migrate/", version)
    end
    # rest of extensions (except site)    
    Spree::Extension.descendants.select{|ext| !ext.root.starts_with?(SPREE_ROOT) and not ext.name == "SiteExtension" }.each do |extension|
      ActiveRecord::Migrator.migrate("#{extension.root}/db/migrate/", version)
    end    
    # everything else (basically the site extension if any)
    Spree::Extension.descendants.each do |extension|
      ActiveRecord::Migrator.migrate("#{extension.root}/db/migrate/", version)
    end    
    Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end

  desc "Loading db/loadfrom for spree and each extension where you specify dir by rake db:load_dir[loadfrom]"
  task :load_dir , [:dir] => :environment do |t , args|
    dir = args.dir
    fixtures = ActiveSupport::OrderedHash.new  
    ruby_files = ActiveSupport::OrderedHash.new
    unless ENV['SKIP_CORE'] and dir == "sample"
      Dir.glob(File.join(SPREE_ROOT, "db", dir , '*.{yml,csv,rb}')).each do |fixture_file|
        ext = File.extname fixture_file
        if ext == ".rb"
          ruby_files[File.basename(fixture_file, '.*')]  = fixture_file
        else
          fixtures[File.basename(fixture_file, '.*')]  = fixture_file
        end
      end
    end
    Spree::ExtensionLoader.instance.db_paths(dir).each do |dir|
      Dir.glob(File.join(dir, '*.{yml,csv,rb}')).each do |fixture_file|
        ext = File.extname fixture_file
        if ext == ".rb"
          ruby_files[File.basename(fixture_file, '.*')]  = fixture_file
        else
          fixtures[File.basename(fixture_file, '.*')]  = fixture_file
        end
      end
    end
    fixtures.sort.each do |fixture , fixture_file|
      # an invoke will only execute the task once
      Rake::Task["db:load_file"].execute( Rake::TaskArguments.new([:file], [fixture_file]) )
    end
    ruby_files.sort.each do |fixture , ruby_file|
      # an invoke will only execute the task once
      Rake::Task["db:load_file"].execute( Rake::TaskArguments.new([:file], [ruby_file]) )
    end
  end

  namespace :migrate do
    desc  'Rollbacks the database one migration and re migrate up. If you want to rollback more than one step, define STEP=x'
    task :redo => [ 'db:rollback', 'db:migrate' ]

    desc 'Resets your database using your migrations for the current environment'
    task :reset => ["db:drop", "db:create", "db:migrate"]

    desc 'Runs the "up" for a given migration VERSION.'
    task :up => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      # spree 
      ActiveRecord::Migrator.run(:up, "#{SPREE_ROOT}/db/migrate/", version)
      # extensions
      Spree::Extension.descendants.select{|ext| ext.root.starts_with?(SPREE_ROOT)}.each do |extension|
        ActiveRecord::Migrator.migrate("#{extension.root}/db/migrate/", version)
      end    
      Spree::Extension.descendants.select{|ext| !ext.root.starts_with?(SPREE_ROOT)}.each do |extension|
        ActiveRecord::Migrator.migrate("#{extension.root}/db/migrate/", version)
      end    
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end

    desc 'Runs the "down" for a given migration VERSION.'
    task :down => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      raise "VERSION is required" unless version
      # spree
      ActiveRecord::Migrator.run(:down, "#{SPREE_ROOT}/db/migrate/", version)
      # extensions
      Spree::Extension.descendants.select{|ext| ext.root.starts_with?(SPREE_ROOT)}.each do |extension|
        ActiveRecord::Migrator.migrate("#{extension.root}/db/migrate/", version)
      end    
      Spree::Extension.descendants.select{|ext| !ext.root.starts_with?(SPREE_ROOT)}.each do |extension|
        ActiveRecord::Migrator.migrate("#{extension.root}/db/migrate/", version)
      end    
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end
  end

  desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
  task :rollback => :environment do
    raise "rollback is not currently supported in Spree (due to complications with extensions)"
    #step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    #ActiveRecord::Migrator.rollback('db/migrate/', step)
    #Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end

  desc "Raises an error if there are pending migrations"
  task :abort_if_pending_migrations => :environment do
    if defined? ActiveRecord
      pending_migrations = []
      # spree
      pending_migrations += ActiveRecord::Migrator.new(:up, "#{SPREE_ROOT}/db/migrate/").pending_migrations
      # extensions
      Spree::Extension.descendants.select{|ext| ext.root.starts_with?(SPREE_ROOT)}.each do |extension|
        pending_migrations += ActiveRecord::Migrator.new(:up, "#{extension.root}/db/migrate/").pending_migrations
      end
      Spree::Extension.descendants.select{|ext| !ext.root.starts_with?(SPREE_ROOT)}.each do |extension|
        pending_migrations += ActiveRecord::Migrator.new(:up, "#{extension.root}/db/migrate/").pending_migrations
      end

      if pending_migrations.any?
        puts "You have #{pending_migrations.size} pending migrations:"
        pending_migrations.each do |pending_migration|
          puts '  %4d %s' % [pending_migration.version, pending_migration.name]
        end
        abort %{Run "rake db:migrate" to update your database then try again.}
      end
    end
  end

end

def find_extension_roots
    current_extensions_path = File.join(File.expand_path(Dir.pwd), 'vendor/extensions')
    all_extension_names = Spree::Extension.descendants
    all_extension_names.collect!{ |x| x.extension_name.tr(' ', '').underscore }
    verified_extension_paths = []

    all_extension_names.each do |ext_name|
      extension_path = File.join(current_extensions_path, ext_name)
      if File.directory?(extension_path)
         verified_extension_paths << extension_path
      end
    end

    extension_roots = verified_extension_paths
    if ENV["EXT"]
      extension_roots = extension_roots.select {|x| /\/(\d+_)?#{ENV["EXT"]}$/ === x }
      if extension_roots.empty?
        puts "Sorry, that extension is not installed."
      end
    end
    extension_roots
end

namespace :spec do
  desc "Runs specs on all available extensions in the current /vendor/extensions directory, pass EXT=extension_name to test a single extension"
  task :extensions => "db:test:prepare" do
    result = 0
    extension_roots = find_extension_roots
    extension_roots.each do |directory|
      if File.directory?(File.join(directory, 'spec'))
        chdir directory do
          if RUBY_PLATFORM =~ /win32/
            system "rake.cmd spec SPREE_ENV_FILE=#{RAILS_ROOT}/config/environment"
          else
            system "rake spec SPREE_ENV_FILE=#{RAILS_ROOT}/config/environment"
          end
          result += $?.exitstatus
        end
      end
    end
    raise "Extension specs failed" if result != 0
  end
end


namespace :extensions do
  namespace :test do
    desc "Runs functional tests on all available extensions in the current /vendor/extensions directory, pass EXT=extension_name to test a single extension"
    task :functionals => "db:test:prepare" do
      result = 0
      extension_roots = find_extension_roots
      extension_roots.each do |directory|
        if File.directory?(File.join(directory, 'test/functional'))
          chdir directory do
            system "rake test:functionals SPREE_ENV_FILE=#{RAILS_ROOT}/config/environment"
            result += $?.exitstatus
          end
        end
      end
      raise "Extension functional tests failed" if result != 0
    end

    desc "Runs unit tests on all available extensions in the current /vendor/extensions directory, pass EXT=extension_name to test a single extension"    
    task :units => "db:test:prepare" do
      result = 0
      extension_roots = find_extension_roots
      extension_roots.each do |directory|
        if File.directory?(File.join(directory, 'test/unit'))
          chdir directory do
            system "rake test:units SPREE_ENV_FILE=#{RAILS_ROOT}/config/environment"
            result += $?.exitstatus
          end
        end
      end
      raise "Extension unit tests failed" if result != 0
    end 
          
  end

    desc "Runs all tests on all available extensions in the current /vendor/extensions directory, pass EXT=extension_name to test a single extension"   
    task :test => "db:test:prepare" do
      result = 0
      extension_roots = find_extension_roots
      extension_roots.each do |directory|
        if File.directory?(File.join(directory, 'test'))
          chdir directory do
            system "rake test SPREE_ENV_FILE=#{RAILS_ROOT}/config/environment"
            result += $?.exitstatus
          end
        end
      end
      raise "Extension tests failed" if result != 0
    end  
  
end

# Load any custom rakefiles from extensions
[RAILS_ROOT, SPREE_ROOT].uniq.each do |root|
  Dir[root + '/vendor/extensions/*/lib/tasks/*.rake'].sort.each { |ext| load ext }
end
