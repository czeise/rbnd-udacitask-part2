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

      menu.choice('Or create a new list') { create_list }
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

  def view_list(list)
    list.all
    puts

    @cli.choose do |menu|
      menu.prompt = 'Please select an option.'
      menu.choice('Add a new item') { add_item }
      menu.choice('Mark a to-do item complete') { mark_complete }
      menu.choice('Filter the list by item type') { filter }
      menu.choice('Delete an item') { delete }
      menu.choice('Return to the main menu') { main_menu }
    end
  end

  def create_list
  end
end
