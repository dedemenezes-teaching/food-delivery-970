class Router
  def initialize(meals_controller, customers_controller, sessions_controller, orders_controller)
    @meals_controller = meals_controller
    @customers_controller = customers_controller
    @sessions_controller = sessions_controller
    @orders_controller = orders_controller
    @running = true
  end

  def run
    while @running
      @employee = @sessions_controller.login
      while @employee
        if @employee.manager?
          route_manager_action
        else
          route_rider_action
        end
      end
      print `clear`
    end
  end

  private

  def route_manager_action
    print_manager_menu
    choice = gets.chomp.to_i
    print `clear`
    manager_action(choice)
  end

  def route_rider_action
    print_rider_menu
    choice = gets.chomp.to_i
    print `clear`
    rider_action(choice)
  end

  def print_manager_menu
    puts "--------------------"
    puts "------- MENU -------"
    puts "--------------------"
    puts "1. Add new meal"
    puts "2. List all meals"
    puts "3. Add new customer"
    puts "4. List all customers"
    puts "5. Add new order"
    puts "6. List all undelivered orders"
    puts "7. Log out"
    puts "8. Exit"
    print "> "
  end

  def print_rider_menu
    puts "--------------------"
    puts "------- MENU -------"
    puts "--------------------"
    puts "1. List all my undelivered orders"
    puts "2. Mark one of my orders as delivered"
    puts "5. Log out"
    puts "6. Exit"
    print "> "
  end

  def manager_action(choice)
    case choice
    when 1 then @meals_controller.add
    when 2 then @meals_controller.list
    when 3 then @customers_controller.add
    when 4 then @customers_controller.list
    when 5 then @orders_controller.add
    when 6 then @orders_controller.list_undelivered
    when 7 then logout!
    when 8 then stop!
    else puts "Try again..."
    end
  end

  def rider_action(choice)
    case choice
    when 1 then @orders_controller.list_my_orders(@employee)
    when 2 then @orders_controller.mark_as_delivered(@employee)
    when 5 then logout!
    when 6 then stop!
    else puts "Try again..."
    end
  end

  def logout!
    @employee = nil
  end

  def stop!
    logout!
    @running = false
  end
end
