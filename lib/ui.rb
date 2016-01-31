# Defines the command line user interface for UdaciList
class UI
  def initialize
    @cli = HighLine.new
  end

  def main_menu(options = {})
    # If called internally, a new set of lists is not passed in.
    @lists = options[:lists] unless !options[:lists]

    menu_title

    @cli.choose do |menu|
      menu.prompt =
        'Please select an option.'

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

  def add_todo(list)
    description = @cli.ask('Enter a description for your to-do item.')

    options = {}

    due = @cli.ask(
      'Enter a due date for your to-do item (optional). Invalid dates will be' \
      ' ignored.')
    priority =
    @cli.ask('Enter a priority for your to-do item (optional).') do |q|
      q.in = ['', 'low', 'medium', 'high']
    end

    puts "Due: #{due}"
    puts "Priorty: #{priority}"

    options[:due] = due unless due == ''
    options[:priority] = priority unless priority == ''

    list.add('todo', description, options)

    view_list(list)
  end

  def add_item(list)
    puts 'What type of item would you like to add?'
    @cli.choose do |menu|
      menu.prompt = 'Please select an option.'
      menu.choice('To-do') { add_todo(list) }
      menu.choice('Event') { add_event(list) }
      menu.choice('Link') { add_link(list) }
    end
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
    UdaciList.new(title: title)
    main_menu
  end
end
