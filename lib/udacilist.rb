# UdaciList class
class UdaciList
  attr_reader :title, :items

  def initialize(options = {})
    @title = options[:title]
    @items = []
  end

  def add(type, description, options = {})
    type = type.downcase
    if type == 'todo'
      @items.push TodoItem.new(description, options)
    elsif type == 'event'
      @items.push EventItem.new(description, options)
    elsif type == 'link'
      @items.push LinkItem.new(description, options)
    else
      raise UdaciListErrors::InvalidItemType,
            "#{type} is not a valid item type."
    end
  end

  def delete(index)
    if index > @items.length
      raise UdaciListErrors::IndexExceedsListSize,
            "There are fewer than #{index} items in the list."
    end
    @items.delete_at(index - 1)
  end

  def title_block
    if @title
      puts '-' * @title.length
      puts @title
      puts '-' * @title.length
    else
      puts '-' * 15
      puts
      puts '-' * 15
    end
  end

  def all
    table = Terminal::Table.new(title: @title, style: { width: 80 })

    @items.each_with_index do |item, position|
      row = [position + 1, item.details[0], item.details[1]]
      table.add_row row
    end

    puts table
  end

  def filter(type)
    type = type.downcase
    if type == 'todo'
      item_class = TodoItem
    elsif type == 'event'
      item_class = EventItem
    elsif type == 'link'
      item_class = LinkItem
    else
      raise UdaciListErrors::InvalidItemType,
            "#{type} is not a valid item type."
    end

    table = Terminal::Table.new(title: @title, style: { width: 80 })

    @items.select { |item| item.class == item_class }.each_with_index do |item, position|
      row = [position + 1, item.details[0], item.details[1]]
      table.add_row row
    end

    puts table
  end
end
