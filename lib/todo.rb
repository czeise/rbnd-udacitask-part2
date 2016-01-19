require_relative 'errors'

# TodoItem class
class TodoItem
  include Listable
  attr_reader :description, :due, :priority

  def initialize(description, options = {})
    @description = description
    @due = options[:due] ? Chronic.parse(options[:due]) : options[:due]

    return unless options[:priority]

    unless %w(high medium low).include?(options[:priority])
      raise UdaciListErrors::InvalidPriorityValue,
            "#{options[:priority]} is not a valid priority."
    end
    @priority = options[:priority]
  end

  def details
    format_description(@description) + 'due: ' +
      format_date(first_date: @due) +
      format_priority(@priority)
  end
end
