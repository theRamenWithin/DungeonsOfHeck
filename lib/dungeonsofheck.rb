# Import local modules
require_relative 'main'
require_relative 'actions'
require_relative 'battle'



# Start Game
if ARGV.empty?
    new_game = Game.new
    new_game.main_menu
elsif ARGV[0] == "-h" || ARGV[0] == "--help"
    puts "--- Help ---"
    puts "Usage:"
    puts "  To install this gem, run:\n"
    puts "  gem install ./dungeonsofheck-1.0.gem"
    puts "  irb"
    puts "  require 'dungeonsofheck'"
    puts "  OR"
    puts "  ruby ./lib/dungeonsofheck.rb"
    puts "Options:"
    puts "  -h or --html        # get help file"
    puts "Example:"
    puts "  ruby ./lib/dungeonsofheck.rb -h"
end