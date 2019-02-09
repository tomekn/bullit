require 'clamp'
require 'ap'

require "bullet_journal/version"
require "bullet_journal/file"

module BulletJournal
  class Error < StandardError; end
  
  Clamp do
    option "--loud", :flag, "say it loud"

    subcommand "generate", "generator functions" do
      subcommand "today", "creates task file for today" do
        def execute
          BulletJournal::File.generate_today_file(loud?)
        end
      end
    end

    subcommand "tasks", "manage today's tasks" do
      subcommand "list", "list your tasks" do
        def execute
          ap BulletJournal::File.today_tasks
        end
      end

      subcommand "add", "add a task" do
        parameter "TEXT", "what the task is", required: true
        def execute
          BulletJournal::File.add_task(text)
        end
      end
    end
  end
end
