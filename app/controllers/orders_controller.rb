require_relative '../views/orders_view'
require_relative '../views/meals_view'
require_relative '../views/customers_view'

class OrdersController
  def initialize(order_repository, meal_repository, customer_repository, employee_repository)
    @order_repository = order_repository
    @meal_repository = meal_repository
    @customer_repository = customer_repository
    @employee_repository = employee_repository
    @orders_view = OrdersView.new
    @meals_view = MealsView.new
    @customers_view = CustomersView.new
    @sessions_view = SessionsView.new
  end

  def add
    # MEAL
    # 1. Get all the meals
    meals = @meal_repository.all
    # 2. display all the meals
    @meals_view.display(meals)
    # 3. Ask the user which one to add
    meal_index = @orders_view.ask_user_for(:index).to_i - 1
    meal = meals[meal_index]

    # CUSTOMER
    # 1. Get all the customers
    customers = @customer_repository.all
    # 2. Display all the customers
    @customers_view.display(customers)
    # 3. Ask the user which customer to add
    customer_index = @orders_view.ask_user_for(:index).to_i - 1
    customer = customers[customer_index]

    # EMPLOYEE
    # 1. Get all riders
    riders = @employee_repository.all_riders
    # 2. Display all the riders
    @sessions_view.display(riders)
    # 3. Ask the user which rider to add
    rider_index = @orders_view.ask_user_for(:index).to_i - 1
    rider = riders[rider_index]

    # Instantiate order
    order = Order.new(meal: meal, customer: customer, employee: rider)
    # add to the repository
    @order_repository.create(order)
  end

  def list_undelivered
    # 1. Get undelivered orders (order Repo)
    undelivered_orders = @order_repository.undelivered_orders
    # 2. Display orders (orders view)
    @orders_view.display(undelivered_orders)
  end

  def list_my_orders(current_user)
    # Get the orders assingned to the current user
    my_orders = @order_repository.my_undelivered_orders(current_user)
    # Display the orders
    @orders_view.display_my_orders(my_orders)
    my_orders
  end

  def mark_as_delivered(current_user)
    # 1. get the user all undelivered orders
    # 2. display them on the terminal
    my_undelivered_orders = list_my_orders(current_user)
    # 3 Ask for the index
    index = @orders_view.ask_user_for(:index).to_i - 1
    # 3.1 get the order to mark
    order_to_mark = my_undelivered_orders[index]
    @order_repository.mark_order_as_delivered(order_to_mark)
  end
end
