require 'pathname'
require 'yaml'
require 'pry'
require 'ap'

require 'bullet_journal/task'

module BulletJournal
  class File
    def self.generate_today_file(loud)
      today_file.dirname.mkpath

      unless today_file.exist?
        t = Time.now

        title = "Journal for #{t.strftime('%m/%d/%y')}"

        file_contents = {
          title: title,
          tasks: incomplete_tasks_from_yesterday
        }

        today_file.write(YAML.dump(file_contents))
        
        puts "#{today_file.to_s} created." if loud
      end
    end

    def self.incomplete_tasks_from_yesterday
      if yesterday_file.exist?
        file = YAML.load(yesterday_file.read)
        return {} if file[:tasks].empty?
        file[:tasks].reject{ |t| t.complete == true }
      end
    end

    def self.today_tasks
      YAML.load(today_file.read)[:tasks]
    end

    def self.add_task(text)
      file = YAML.load(today_file.read)

      if file[:tasks].nil?
        file[:tasks] = [ Task.new(text: text).to_h ]
      else
        file[:tasks] = today_tasks << Task.new(text: text).to_h
      end

      today_file.write(YAML.dump(file))
    end

    def self.today_file
      t = Time.now

      year    = t.strftime "%Y"
      week    = t.strftime "%W" 
      weekday = t.strftime "%u"

      Pathname("tasks/#{year}/#{week}/#{weekday}.yaml")
    end

    def self.yesterday_file
      t = Time.now

      year    = t.strftime "%Y"
      week    = t.strftime "%W" 
      weekday = t.strftime("%u").to_i

      if weekday > 1
        yesterday_file = Pathname("tasks/#{year}/#{week}/#{(weekday - 1).to_s}.md")
      end
    end
  end
end