require 'clamp'
require 'tty-table'
require 'tty-prompt'

require "bullit/version"
require "bullit/file"

module Bullit
  class Error < StandardError; end
  
  Clamp do
    option "--loud", :flag, "say it loud"

    subcommand "generate", "generator functions" do
      subcommand "today", "creates task file for today" do
        def execute
          Bullit::File.generate_today_file(loud?)
        end
      end
    end

    subcommand "tasks", "manage today's tasks" do
      subcommand "list", "list your tasks" do
        def execute
          show_tasks
        end
      end

      subcommand "add", "add a task" do
        option "--text", "TEXT", "what the task is"
        def execute
          prompt = TTY::Prompt.new
          text = prompt.ask('what do you need to do?') if text.nil?
          Bullit::File.add_task(text)
          show_tasks
        end
      end
      
      subcommand "delete", "delete a task" do
        parameter "TASK_NUMBER", "what the task is", required: true
        def execute
          Bullit::File.delete_task(task_number.to_i)
          show_tasks
        end
      end

      subcommand "complete", "complete a task" do
        parameter "TASK_NUMBER", "what the task is", required: true
        def execute
          Bullit::File.complete_task(task_number.to_i)
          show_tasks
        end
      end
    end

    def show_tasks
      if tasks = Bullit::File.today_tasks
        tasks = tasks.each_with_index.map{ |t,i| [i,t[:text], t[:complete] == true ? ' ✅' : ' ❌']}

        puts TTY::Table.new(['#', 'Task', ''], tasks).render(:unicode)
      elsif tasks == {}
        puts "There's no tasks for today"
      end
    end
  end
end
