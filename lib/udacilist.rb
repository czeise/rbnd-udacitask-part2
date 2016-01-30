# UdaciList class
class UdaciList
  attr_reader :title, :items

  def initialize(options = {})
    options[:title] ? @title = options[:title] : @title = 'Untitled List'
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

  def format_complete(item)
    if item.class == TodoItem
      if item.completed_status
        '[X]'
      else
        '[ ]'
      end
    else
      ' '
    end
  end

  def generate_table(list)
    table = Terminal::Table.new(title: @title, style: { width: 80 })

    list.each_with_index do |item, position|
      checkbox = format_complete(item)
      row = [position + 1, item.item_type, checkbox, item.details[0], item.details[1]]
      table.add_row row
    end

    table
  end

  def all
    puts generate_table(@items)
  end

  def get_item_class(type)
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
    item_class
  end

  def filter(type)
    item_class = get_item_class(type)

    filtered_items = @items.select { |item| item.class == item_class }

    if filtered_items.length > 0
      table = generate_table(filtered_items)

      output = table

    else
      output =
      "Can't generate list as there are no '#{type}' items in the list."
    end

    puts output
  end

  def mark_complete(index)
    if (@items[index - 1].class == TodoItem) &&
       !@items[index - 1].completed_status
      @items[index - 1].completed_status = true
    else
      # Note that I chose not to throw an error here.
      puts 'Only incomplete to-do items can be marked complete.'
    end
  end
end
