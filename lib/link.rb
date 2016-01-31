# This class defines links for use by UdaciList.
class LinkItem
  include Listable
  attr_reader :description, :site_name

  def initialize(url, options = {})
    @description = url
    @site_name = options[:site_name]
  end

  def details
    # Dropping 'site name: ' from description to shorten column width.
    [format_description(@description), format_name(@site_name)]
  end

  def item_type
    'Link'
  end
end
