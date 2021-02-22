module Battle

    def fight
        # Shorter variables for monster attributes
        mon = Game::MON_LIST[Game::ROOM_ATTR[Game::PLAYER_ATTR[:player_location_id]][:monster_id]]

        # Monster intro text
        puts mon[:monster_intro]
        puts "\nFight to survive!"

        # Main combat loop
        while mon[:monster_hp] > 0
            prompt.keypress("Press space or enter to attack!".red, keys: [:space, :return])
            attack = rand(Game::PLAYER_ATTR[:player_attack])
            mon[:monster_hp] -= attack

            unless mon[:monster_hp] < 0
                puts "\n#{mon[:name].upcase.red} - HP #{mon[:monster_hp]}/#{mon[:monster_hp_max]}"
            else
                puts "\n#{mon[:name].upcase.red} - HP 0/#{mon[:monster_hp_max]}"
            end

            puts "Using your #{'PAW'.light_green}, you boop the snoot of #{mon[:name].upcase.red} doing #{attack} damage."

            if mon[:monster_hp] < 1
                break
            end
            
            puts mon[:monster_attack_text]
            puts "\nYou feel slightly demoralised."
        end

        #Victory announcement and set monster defeat
        Game::ROOM_ATTR[Game::PLAYER_ATTR[:player_location_id]][:monster_defeat?] = true
        puts mon[:monster_defeat_text]
        puts "\n#{'Victory!'.blue}"

        # If monster has loot, add it to player inventory with message.
        unless mon[:loot].nil?
            Game::PLAYER_ATTR[:inventory] << Game::ITEM_LIST[mon[:loot]]
            puts "\n#{mon[:name].upcase.red} dropped #{Game::ITEM_LIST[mon[:loot]][:name].upcase.light_green}. You add it to your bag."
        end

        prompt.keypress("Press space or enter to continue".green, keys: [:space, :return])
    
        # If defeating the monster has an affect on the room, call the block
        unless mon[:monster_defeat_effect].nil?
            mon[:monster_defeat_effect].call
        end
    end

    module_function :fight
end