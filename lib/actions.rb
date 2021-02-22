module Action

    # Method for moving between locations
    def move
        prompt.select("Where will you move to?".blue) do |menu|
            Game::ROOM_ATTR[Game::PLAYER_ATTR[:player_location_id]][:move_locations].each do |move_to|
                # If the location is open, list it as an option.
                if move_to[:open?] 
                    menu.choice "#{move_to[:name].capitalize}", -> {Game::PLAYER_ATTR[:player_location_id] = move_to[:id]}
                end
            end
            menu.choice "Cancel", -> {next}
        end
    end

    def interact(interact_object)
        prompt.keypress("Press space or enter to continue".green, keys: [:space, :return])

        # If the interactible has not been used, puts the use success message.
        if !interact_object[:used?] 

            # If the object needs something to use, check inventory for anything with a matching item_id.
            if !interact_object[:needs].nil?
                # If there's a match, delete the item from the inventory and continue, else fail.
                if Game::PLAYER_ATTR[:inventory].any? {|h| h[:item_id] == interact_object[:needs]}
                    Game::PLAYER_ATTR[:inventory].delete_at(Game::PLAYER_ATTR[:inventory].index { |v| v[:name] == Game::ITEM_LIST[interact_object[:needs]][:name] })
                else
                    return puts interact_object[:use_text_fail]
                end
            end
            
            # Indicate that the object is now used and puts the successful use message
            interact_object[:used?] = true
            puts interact_object[:use_text_success]

            # Unless the interactible gives no item, add the item to the player inventory.
            unless interact_object[:contains].nil?
                Game::PLAYER_ATTR[:inventory] << Game::ITEM_LIST[interact_object[:contains]]
                puts "\n#{Game::PLAYER_ATTR[:inventory].last[:name].upcase.light_green} was added to inventory."
            end

            # If the interactible has an affect on the room, call used effect proc
            unless interact_object[:use_effect].nil?
                interact_object[:use_effect].call
            end
        
        # If the interactible has been used, put the used message
        elsif interact_object[:used?] 
            puts interact_object[:used_text] 
        end
    end

    # Method for using interactibles in a room if they exist
    def use
        inter = Game::ROOM_ATTR[Game::PLAYER_ATTR[:player_location_id]][:interactibles]

        # Unless there's nothing to use, list print out thing to interact with.
        unless inter.nil?
            prompt.select("What will you use?") do |menu|
                inter.each do |interact_object|
                    if interact_object[:accessible?]
                        menu.choice "#{interact_object[:name]}", -> {puts "#{interact_object[:use_text_look]}"; interact(interact_object)}
                    end
                end
            end
        else
            puts "There is nothing around you that you can use."
        end
        prompt.keypress("Press space or enter to continue".green, keys: [:space, :return])
    end

    # Method for displaying the contents of the player inventory
    def bag
        bag_contents
        prompt.keypress("Press space or enter to continue".green, keys: [:space, :return])
    end

    def bag_contents
        if Game::PLAYER_ATTR[:inventory].length > 0
            rows = Game::PLAYER_ATTR[:inventory].map { |v| [v[:name].light_green,v[:examine_text]] }
            bag_table = TTY::Table.new(header: ["Item", "Description"], rows: rows)
            puts bag_table.render(:unicode, multiline: true, padding: [1,0])
        else
            puts "\nYour bag is empty. You shake the bag in your mouth sadly."
        end
    end

    # Method for exiting to main menu
    def exit_game
        prompt.select("Are you sure you want to quit and return to the main menu? (progress will be lost)".red) do |menu|
            menu.choice "Yes", -> {Game.new.main_menu}
            menu.choice "No", -> {Game.new.game_menu}
        end
    end

    module_function :move, :interact, :use, :bag, :bag_contents, :exit_game
end