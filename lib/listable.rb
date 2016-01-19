# Listable module
module Listable
  # Listable methods go here
  def format_description(description)
    "#{description}".ljust(30)
  end

  def format_date(options = {})
    dates = options[:first_date].strftime('%D') if options[:first_date]

    if options[:second_date]
      dates << ' -- ' + options[:second_date].strftime('%D')
    end

    dates = 'N/A' unless dates
    dates
  end
end
