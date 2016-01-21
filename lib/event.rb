# EventItem class
class EventItem
  include Listable
  attr_reader :description, :start_date, :end_date

  def initialize(description, options = {})
    @description = description
    @start_date = Date.parse(options[:start_date]) if options[:start_date]
    @end_date = Date.parse(options[:end_date]) if options[:end_date]
  end

  def details
    # Dropping 'event dates: ' from description to shorten column width
    [format_description(@description),
     format_date(first_date: @start_date, second_date: @end_date)]
  end

  def item_type
    'Event'
  end
end
