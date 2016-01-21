require_relative 'errors'

# TodoItem class
class TodoItem
  include Listable
  attr_reader :description, :due, :priority
  attr_accessor :completed_status

  def initialize(description, options = {})
    @description = description
    @due = options[:due] ? Chronic.parse(options[:due]) : options[:due]
    @completed_status = false

    return unless options[:priority]

    unless %w(high medium low).include?(options[:priority])
      raise UdaciListErrors::InvalidPriorityValue,
            "#{options[:priority]} is not a valid priority."
    end
    @priority = options[:priority]
  end

  def details
    # Dropping 'due: ' from description to shorten column width
    [format_description(@description),
     format_date(first_date: @due) + format_priority(@priority)]
  end

  def item_type
    'To-do'
  end
end
