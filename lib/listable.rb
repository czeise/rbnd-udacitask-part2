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
    value = ' ⇧'.colorize(:red) if priority == 'high'
    value = ' ⇨'.colorize(:yellow) if priority == 'medium'
    value = ' ⇩'.colorize(:green) if priority == 'low'
    value = '' unless priority
    value
  end

  def format_name(name)
    name ? name : ''
  end
end
