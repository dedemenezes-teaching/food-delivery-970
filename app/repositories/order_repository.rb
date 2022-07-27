require_relative '../models/order'
require 'csv'

class OrderRepository
  def initialize(csv_file_path, meal_repository, customer_repository, employee_repository)
    @csv_file_path = csv_file_path
    @orders = []
    @meal_repository = meal_repository
    @customer_repository = customer_repository
    @employee_repository = employee_repository
    load_csv if File.exist? @csv_file_path
  end

  def create(order)
    order.id = @orders.empty? ? 1 : @orders.last.id + 1
    @orders << order
    save_csv
  end

  def undelivered_orders
    @orders.reject { |order| order.delivered? }
  end

  def my_undelivered_orders(current_user)
    undelivered_orders.select { |order| order.employee == current_user }
  end

  def mark_order_as_delivered(order)
    # 4. MARK AS DELIVERED!!!!
    order.deliver!
    # 5. save it
    save_csv
  end

  private

  def save_csv
    CSV.open(@csv_file_path, "wb") do |csv|
      csv << %i[id delivered meal_id customer_id employee_id]
      @orders.each do |order|
        csv << [order.id, order.delivered?, order.meal.id, order.customer.id, order.employee.id]
      end
    end
  end

  def load_csv
    CSV.foreach(@csv_file_path, headers: :first_row, header_converters: :symbol) do |row|
      # parse from csv file to ruby data types
      row[:id] = row[:id].to_i
      row[:delivered] = row[:delivered] == 'true' # 'true' || 'false'
      # from ids retrive the ACTUAL instances
      row[:meal] = @meal_repository.find(row[:meal_id].to_i)
      row[:customer] = @customer_repository.find(row[:customer_id].to_i)
      row[:employee] = @employee_repository.find(row[:employee_id].to_i)
      @orders << Order.new(row)
    end
  end
end
