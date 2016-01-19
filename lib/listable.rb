# Listable module
module Listable
  # Listable methods go here
  def format_description(description)
    "#{description}"
  end

  def format_date(options = {})
    dates = options[:first_date].strftime('%D') if options[:first_date]

    if options[:second_date]
      dates << ' -- ' + options[:second_date].strftime('%D')
    end

    dates = 'N/A' unless dates
    dates
  end

  def format_priority(priority)
    value = ' ⇧' if priority == 'high'
    value = ' ⇨' if priority == 'medium'
    value = ' ⇩' if priority == 'low'
    value = '' unless priority
    value
  end

  def format_name(name)
    name ? name : ''
  end
end
