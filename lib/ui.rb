# Defines the command line user interface for UdaciList
class UI
  def initialize
    @cli = HighLine.new
  end

  def main_menu(options = {})
    # If called internally, a new set of lists is not passed in.
    @lists = options[:lists] if options[:lists]

    menu_title

    @cli.choose do |menu|
      menu.prompt = 'Please select an option.'

      @lists.each do |list|
        menu.choice("View #{list.title}") { view_list(list) }
      end

      menu.choice('Create a new list') { create_list }
      menu.choice('Quit UdaciList') { exit }
    end
  end

  private

  def menu_title
    puts
    main_title = 'UDACILIST - MAIN MENU'
    puts '*' * main_title.length
    puts main_title
    puts '*' * main_title.length
  end

  def todo_options
    options = {}

    due = @cli.ask(
      'Enter a due date for your to-do item (optional). Invalid dates will be' \
      ' ignored.')
    priority =
    @cli.ask('Enter a priority for your to-do item (optional).') do |q|
      q.in = ['', 'low', 'medium', 'high']
    end

    options[:due] = due unless due == ''
    options[:priority] = priority unless priority == ''

    options
  end

  def event_options
    options = {}

    start_date = @cli.ask('Enter a date for your event (optional).')
    end_date = @cli.ask('Enter an end date for your event (if it spans ' \
      'multiple days).')

    options[:start_date] = start_date unless start_date == ''
    options[:end_date] = end_date unless end_date == ''

    options
  end

  def link_options
    options = {}
    options[:site_name] = @cli.ask('What is the name of the site?')
    options
  end

  def add_link(list)
    description = @cli.ask("Enter the url of the site you'd like to add.")
    list.add('link', description, link_options)
  end

  def add_event(list)
    description = @cli.ask('Enter a description for your item.')
    list.add('event', description, event_options)
  end

  def add_todo(list)
    description = @cli.ask('Enter a description for your item.')
    list.add('todo', description, todo_options)
  end

  def add_item(list)
    puts 'What type of item would you like to add?'
    @cli.choose do |menu|
      menu.prompt = 'Please select an option.'
      menu.choice('To-do') { add_todo(list) }
      menu.choice('Event') { add_event(list) }
      menu.choice('Link') { add_link(list) }
    end

    view_list(list)
  end

  def mark_complete(list)
    item_num = @cli.ask(
      "What is the number of the to-do item you'd like to mark complete?",
      Integer) do |q|
      q.in = 1..list.items.length
    end

    list.mark_complete(item_num.to_i)

    view_list(list)
  end

  def filter(list)
    puts "Choose the type of item you'd like to filter by."
    type = @cli.choose do |menu|
      menu.prompt = 'Please select an option.'
      menu.choice('To-do')
      menu.choice('Event')
      menu.choice('Link')
    end
    puts
    list.filter(type)
    puts

    @cli.choose do |menu|
      menu.prompt = 'Please select an option.'
      menu.choice('Return to full list') { view_list(list) }
      menu.choice('Return to the main menu') { main_menu }
    end
  end

  def delete(list)
    item_num = @cli.ask('Which item would you like to delete?', Integer) do |q|
      q.in = 1..list.items.length
    end

    if @cli.agree("Are you sure you want to delete ##{item_num}?")
      list.delete(item_num.to_i)
    end
    view_list(list)
  end

  def view_list(list)
    puts
    list.all
    puts

    @cli.choose do |menu|
      menu.prompt = 'Please select an option.'
      menu.choice('Add a new item') { add_item(list) }
      menu.choice('Mark a to-do item complete') { mark_complete(list) }
      menu.choice('Filter the list by item type') { filter(list) }
      menu.choice('Delete an item') { delete(list) }
      menu.choice('Return to the main menu') { main_menu }
    end
  end

  def create_list
    title = @cli.ask('Enter a title for your list.')
    if title.length > 0
      UdaciList.new(title: title)
    else
      UdaciList.new
    end
    main_menu
  end
end
