# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'helpers/number_helper'
class Restaurant
  include NumberHelper
  @@filepath = nil
  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT,path)
  end
  
  attr_accessor :name, :cuisine , :price
  
  def self.file_exists?
    #return true if the File path exists and FilePath != null
    return @@filepath && File.exists?(@@filepath)
  end
  
  def self.file_useable?
    return false unless @@filepath
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end

  def self.create_file
    #create the restaurant file
    File.open(@@filepath, 'w') unless file_exists?
    #return instances of restaurant
    return file_useable?
  end
  
  def self.saved_restaurants
    # we need to ask ourselves, do we want a fresh copy each time
    # or do we want to store the results in a variable
    restaurants = []
    if file_useable?
      file = File.new(@@filepath,'r')
      file.each_line do |line|
        restaurants << Restaurant.new.import_line(line.chomp)
      end
      file.close
    end
    return restaurants
    #return instances of restaurant
  end
  
  def self.build_from_questions
    args = {}
    print "Restaurant Name: "
    args[:name] = gets.chomp.strip
    
    print "Cuisine Type: "
    args[:cuisine] = gets.chomp.strip
    
    print "Average Price: "
    args[:price] = gets.chomp.strip
    
    return self.new(args)
  end
    
  def initialize(args = {})
    @name    = args[:name]    || ""
    @cuisine = args[:cuisine] || ""
    @price   = args[:price]   || ""
  end
  
  def import_line(line)
    line_array = line.split("\t")
    @name, @cuisine, @price = line_array
    return self
  end

  def save
    return false unless Restaurant.file_useable?
    File.open((@@filepath), 'a') do |file|  
      file.puts "#{[@name,@cuisine,@price].join("\t")}\n"
    end
    return true
  end
  
  def formatted_price
    number_to_currency(@price)
  end
end
