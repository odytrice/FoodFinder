## Food Finder ##
#Launch this Ruby File to Bootstrap Application
APP_ROOT = File.dirname(__FILE__)

## Usage ##
# require "#{APP_ROOT}/lib/guide"
# require File.join(APP_ROOT, 'lib', 'guide.rb')
# require

# Alternatively you can add folders to the global search path
# using the special $: 
$:.unshift(File.join(APP_ROOT,'lib'))

#So that you can have
require "guide"

guide = Guide.new("restaurants.txt")
guide.launch