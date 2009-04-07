unless Rake::TaskManager.methods.include?(:redefine_task)
  module Rake
    module TaskManager
      def redefine_task(task_class, args, &block)
        task_name, deps = resolve_args([args])
        task_name = task_class.scope_name(@scope, task_name)
        deps = [deps] unless deps.respond_to?(:to_ary)
        deps = deps.collect {|d| d.to_s }
        task = @tasks[task_name.to_s] = task_class.new(task_name, self)
        task.application = self
        task.add_description(@last_description)
        @last_description = nil
        task.enhance(deps, &block)
        task
      end
    end
    class Task
      class << self
        def redefine_task(args, &block)
          Rake.application.redefine_task(self, args, &block)
        end
      end
    end
  end
end


def redefine_task(args, &block)
  Rake::Task.redefine_task(args, &block)
end

namespace :db do
  namespace :test do
    desc 'Prepare the test database and migrate schema'
    redefine_task :prepare => :environment do
      if defined?(ActiveRecord::Base) && !ActiveRecord::Base.configurations.blank?
        Rake::Task[{  :sql  => "db:test:clone_structure", 
                      :ruby => "db:test:clone", 
                      :migration => "db:test:migrate", 
                      :static_sql => "db:test:load_structure"
                   }[ActiveRecord::Base.schema_format]].invoke
      end
    end

    desc 'Use the migrations to create the test database'
    task :migrate => 'db:test:purge' do
      begin
        ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['development'])
        schema_version = ActiveRecord::Base.count_by_sql("SELECT version AS count_all FROM schema_info LIMIT 1;")
        ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
        ActiveRecord::Migrator.migrate("db/migrate/", schema_version)
      rescue
        puts "The development database doesn't exist or no migrations have been run on it."
      end
    end

    desc 'Use a static sql script to create the test database'
    task :load_structure => "db:test:purge" do
      begin
        abcs = ActiveRecord::Base.configurations
        ActiveRecord::Base.establish_connection(:test)
        IO.readlines("db/static_structure.sql").join.split("\n\n").each do |ddl|
          ActiveRecord::Base.connection.execute(ddl.chop)
        end
      rescue
        raise
        puts "Could not load schema from db/static_structure.sql."
      end
    end


  end
end
