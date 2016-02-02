# The main UdaciList class. All list functionality is defined here.
class UdaciList
  attr_reader :title, :items

  @@lists = []
  @@untitled_list_num = 1

  def initialize(options = {})
    if options[:title]
      @title = options[:title]
    else
      @title = "Untitled List #{@@untitled_list_num}"
      @@untitled_list_num += 1
    end
    @items = []
    add_to_lists
  end

  def add(type, description, options = {})
    type = type.downcase
    if %w(todo to-do).include?(type)
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

  def all
    puts generate_table(@items)
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

  def self.all
    @@lists
  end

  def self.ui_mode
    ui = UI.new
    ui.main_menu(lists: all)
  end

  private

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

  def get_item_class(type)
    type = type.downcase
    if %w(todo to-do).include?(type)
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

  def add_to_lists
    @@lists.each do |list|
      if list.title == @title
        raise UdaciListErrors::DuplicateItemError,
              "The list, #{@title}, already exists."
      end
    end

    @@lists << self
  end
end
