class SessionsView
  def ask_for(stuff)
    puts "#{stuff}?"
    print "> "
    return gets.chomp
  end

  def print_wrong_credentials
    puts "Wrong credentials... Try again"
  end

  def display(riders)
    riders.each_with_index do |rider, index|
      puts "#{index + 1} - #{rider.username}"
    end
  end
end
