require 'pathname'
require 'yaml'
require 'tty-prompt'
require 'pry'

require 'bullit/task'

module Bullit
  class File
    def self.generate_today_file(loud)
      today_file.dirname.mkpath unless today_file.dirname.exist?

      unless today_file.exist?
        t = Time.now

        title = "Journal for #{t.strftime('%m/%d/%y')}"

        file_contents = {
          title: title,
          tasks: incomplete_tasks_from_yesterday(loud)
        }

        today_file.write(YAML.dump(file_contents))
        
        puts "#{today_file.to_s} created." if loud
      end
    end

    def self.incomplete_tasks_from_yesterday(loud)
      if yesterday_file.exist?
        file = yesterday_file_contents
        
        return {} if file[:tasks].empty?
        
        file[:tasks].each do |t|
          unless t[:complete] == true
            action = TTY::Prompt.new.select("\nWould you like to complete\n\n\t'#{t[:text]}'\n\nor migrate it to today's entry?\n", %w(complete migrate))
            if action == 'complete'
              t = t.to_task.mark_as_complete
            end
          end
        end

        file[:tasks] = file[:tasks].reject{ |t| t[:complete] == true }

        yesterday_file.write(YAML.dump(file))

        if file[:tasks] == {}
          return nil
        else
          return file[:tasks]
        end
      end
    end

    def self.today_tasks
      YAML.load(today_file.read)[:tasks]
    end

    def self.add_task(text)
      file = today_file_contents

      if file[:tasks] == {}
        file[:tasks] = [ Task.new(text: text).to_h ]
      else
        file[:tasks] = today_tasks << Task.new(text: text).to_h
      end

      today_file.write(YAML.dump(file))
    end

    def self.delete_task(task_number)
      file = today_file_contents

      unless file[:tasks].nil?
        unless file[:tasks][task_number].nil?
          file[:tasks].delete_at(task_number)
        end
      end
      
      today_file.write(YAML.dump(file))
    end

    def self.complete_task(task_number)
      file = today_file_contents

      unless file[:tasks].nil?
        unless file[:tasks][task_number].nil?
          file[:tasks][task_number] = file[:tasks][task_number].to_task.mark_as_complete
          today_file.write(YAML.dump(file))
        end
      end
    end

    def self.today_file
      t = Time.now

      year    = t.strftime "%Y"
      week    = t.strftime "%W" 
      weekday = t.strftime "%u"

      Pathname("#{Dir.home}/.bullit/journal/#{year}/#{week}/#{weekday}.yaml")
    end

    def self.today_file_contents
      YAML.load(today_file.read)
    end

    def self.yesterday_file
      t = Time.now

      year    = t.strftime "%Y"
      week    = t.strftime "%W" 
      weekday = t.strftime("%u").to_i

      # TODO: the logic here is a bit dodgy... it should look for the latest file in case you don't use your machine for more than one day.
      if weekday > 1
        Pathname("#{Dir.home}/.bullit/journal/#{year}/#{week}/#{(weekday - 1).to_s}.yaml")
      else
        Pathname("#{Dir.home}/.bullit/journal/#{year}/#{week-1}/7.yaml")
      end
    end

    def self.yesterday_file_contents
      YAML.load(yesterday_file.read)
    end
  end
end