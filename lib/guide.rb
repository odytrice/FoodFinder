# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'restaurant'
require 'helpers/string_extend'

class Guide
  class Config
    @@actions = ['list','find','add','quit','exit']
    def self.actions; @@actions; end
  end
  
  def initialize (path = nil)
    #locate the restaurant text file at path
    Restaurant.filepath = path
    if Restaurant.file_useable?
      puts "Found restaurant file."
    elsif Restaurant.create_file
      puts "Created restaurant file."
      #or create a new file
    else
      puts "Exiting...\n\n"
      exit!
    end
    
    #exit if create fails
  end
  
  def launch
    introduction
    # action loop
    result = nil
    until result == :quit
      action, args = get_action
      #do that action
      result = do_action(action,args)
      # repeat until user quits
    end
    conclusion
  end
  
  def get_action
    #Keep asking for user input until we get a valid action
    action = nil
    until Guide::Config.actions.include?(action)
      puts "Actions: "+Guide::Config.actions.join(",") if action
      print "> "
      user_response = gets.chomp
      args = user_response.downcase.strip.split(' ')
      action = args.shift
      return action,args
    end
    return action
  end
  
  def do_action(action, args=[])
    case action
    when 'list'
      list(args)
    when "find"
      keyword = args.shift
      find(keyword)
    when "add"
      add
    when "quit"
      return :quit
    when "exit"
      return :quit
    else
      puts "\nI don't understand that command\n"
    end
  end
  
  def list (args=[])
    sort_order = args.shift
    sort_order = args.shift if sort_order == 'by'
    #Make Name Sort the Default
    unless ['name','cuisine','price'].include?(sort_order)
      sort_order = 'name'
    end
    
    output_action_header("Listing Restuarants")
    restaurants = Restaurant.saved_restaurants
    
    restaurants.sort! do |r1,r2|
      case sort_order
      when 'name'
      r1.name.downcase <=> r2.name.downcase
      when 'cuisine'
        r1.name.downcase <=> r2.name.downcase
      when 'price'
        r1.price.to_i <=> r2.price.to_i
      end
    end
    output_restaurant_table(restaurants)
    puts "Sort using: 'list cuisine' or 'list by cuisine'\n\n"
    #display restaurant
  end
  
  def add
    output_action_header("Add a Restaurant")
    #Save to the file
    restaurant = Restaurant.build_from_questions
    if restaurant.save
      puts "\nRestaurant Added\n\n"
    else
      puts "\nSave Error: Restaurant not added\n\n"
    end
  end
  
  def find(keyword = "")
    output_action_header("Find a restaurant")
    if keyword
      #search
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |rest|
        rest.name.downcase.include?(keyword.downcase) ||
        rest.cuisine.downcase.include?(keyword.downcase) ||
        rest.price.to_i <= keyword.to_i
      end
      output_restaurant_table(found)
    else
      puts "Find using a key phrase to search the restaurant list."
      puts "Examples: 'find Tamale','find Mexican', 'find Mex'\n\n"
    end
  end
  
  def introduction
    puts "\n\n<<< Welcome to the Food Finder >>>\n\n"
    puts "This is an interactive guide to help you find the food you crave. \n\n"
  end
  
  def conclusion
    puts "\n<<< Goodbye! >>>\n\n\n"
  end
  
  private
  def output_action_header(text)
    puts "\n#{text.upcase.center(60)}\n\n"
  end
  def output_restaurant_table(restaurants = [])
    print " " + "Name".ljust(30)
    print " " + "Cuisine".ljust(20)
    print " " + "Price".ljust(6) + "\n"
    puts "-" * 60 
    
    restaurants.each do |rest|  
      line = " " << rest.name.titleize.ljust(30)
      line << " " + rest.cuisine.titleize.ljust(20)
      line << " " + rest.formatted_price.rjust(6) + "\n"
      puts line
    end
    
    puts "No listing found" if restaurants.empty?
    puts "-" * 60
  end
end