module BulletJournal
  class Task
    attr_accessor :text, :complete

    def initialize(text:, complete: false, created_at: Time.now)
      @text = text
      @complete = complete
      @created_at = created_at
    end

    def to_h
      {
        text: text,
        complete: complete,
        created_at: Time.now.to_s
      }
    end

    def mark_as_done
      @complete = true
      to_h
    end
  end
end