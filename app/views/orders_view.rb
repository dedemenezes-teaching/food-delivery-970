class OrdersView
  def display(orders)
    orders.each_with_index do |order, index|
      puts "#{index + 1} - #{order.meal.name} - #{order.employee.username}"
    end
  end
  def ask_user_for(stuff)
    puts "#{stuff.capitalize}?"
    print "> "
    return gets.chomp
  end

  def display_my_orders(my_orders)
    my_orders.each_with_index do |order, index|
      puts "#{index + 1} - #{order.meal.name} - #{order.customer.name} - #{order.customer.address}"
    end
  end
end
