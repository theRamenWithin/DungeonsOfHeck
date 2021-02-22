# Import gem modules
require 'tty-box'
require 'tty-font'
require 'tty-table'
require 'tty-prompt'
require 'colorize'

# Error handling classes for input validation
class NotValidName < StandardError
    def initialize(msg="\nForgetful doge, surely you remember your own name? (Name can only contain letters and must be less than 8 characters)".light_blue)
    super(msg)
    end
end
class NotValidAge < StandardError
    def initialize(msg="\nForgetful doge, surely you remember your own age? (Age can only contain numbers)".light_blue)
    super(msg)
    end
end

# Declare methods for gem module functionality
def prompt
    TTY::Prompt.new(symbols: {marker: "🐕"})
end
def font
    TTY::Font.new(:doom)
end

class Game

    # =========================
    # Declare constants for attribute storage
    # =========================
    ROOM_ATTR = [
                {location_id: 0,
                location_name: "Entrance",
                move_locations: [{name: "gate", 
                                id: 1, 
                                open?: true}],
                intro_text: "The dirt road under your beans is cold and dusty. You stand before a tall, iron #{'GATE'.yellow} flanked by high, stone walls. Beside the gate, in the bushes, you spot what could be a #{'CHEST'.green}. Beyond the gate, you see a courtyard and an imposing castle in the distance.",
                look_text: "The entrance feel lonely. A strong breeze kicks up the small stones and dirt from the path, making you squint. The #{'GATE'.yellow} is your only way forward. Beside it, you spot what could be a #{'CHEST'.green}.",
                interactibles: [{name: "Chest", 
                                    needs: nil,
                                    use_text_look: "\nHidden under some low shrubbery, the metal glint of a small chest catches your eye.",
                                    use_text_success: "\nYour nails clack noisily against the #{'CHEST'.green} as you fumble it open and retreive a #{'LETTER'.light_green} from inside. Only now do you notice the stake rising from the ground and realise that you just raided the fallen off mailbox of the #{"HECK WIZARD".red}. Boy is he going to be mad.",
                                    use_text_fail: "\nSomehow you failed to open the #{'CHEST'.green}, even though I didn't program that to be possible.",
                                    used_text: "\nThe #{'BROKEN MAILBOX'.green} lies forlornly under the bush, empty and mailless.",
                                    used?: false,
                                    use_effect: nil,
                                    accessible?: true,
                                    contains: 0}],
                monster?: false,
                monster_defeat?: false,
                visited?: false},

                {location_id: 1,
                location_name: "Courtyard",
                move_locations: [{name: "Entrance", 
                                id: 0, 
                                open?: true},

                                {name: "crypt", 
                                id: 2, 
                                open?: false}],
                intro_text: "You enter the medium sized, gravel covered courtyard via the gate. Dense hedges line the surrounding walls behind and to your side. The middle of the courtyard contains an #{'ALTAR'.green} with shallow pools at its four corners. Between you an the castle you realise is an expansive garden and cemetary. An #{'UNREASONABLY LARGE DOGE'.red} stands in front of the #{'CRYPT DOOR'.yellow} that seems to be your only way forward.",
                look_text: "The sound of water tinkling in the pools around the #{'ALTAR'.green} might be calming if the #{'COURTYARD'.yellow} was not so desolute. The #{'UNREASONABLY LARGE DOGE'.red} continues to block the way to the #{'CRYPT DOOR'.green}.",
                interactibles: [{name: "Crypt Door",
                                    needs: 2,
                                    use_text_look: "\nThe #{'UNREASONABLY LARGE DOGE'.red} was standing guard in front of the #{'CRYPT DOOR'.green} before you gave him a booping he will never forget. It stands tall in dark mahogony, embellished with iron trimming.",
                                    use_text_success: "\nThe #{'KEY'.light_green} goes in after a few good slaps. Twisting it with your mouth, the locking mechanism clunks heavily and the #{'CRYPT DOOR'.green} swings in on your weight revealing a path to the #{'CRYPT'.yellow}.",
                                    use_text_fail: "\nNo amount of pawing and whining at this door will convinced a human to open it for you. Some kind of key shaped hole is the only opening you can see.",
                                    used_text: "\nAn overwhelming feeling of dread washes over you. The #{'CRYPT'.yellow} beckons.",
                                    used?: false,
                                    use_effect: proc {Game::ROOM_ATTR[1][:move_locations][1][:open?] = true},
                                    accessible?: false,
                                    contains: nil},

                                    {name: "Altar",
                                    needs: 1,
                                    use_text_look: "\nThe #{'ALTAR'.green} is a marbled white, stone slab in the center of the courtyard. You jump up with your front paws on the surface and snoot peeking over the top and see a bone shaped recess in the middle of the #{'ALTAR'.green}.",
                                    use_text_success: "\nYou drop the #{'CRYSTAL BONE'.light_green} into the #{'CRYSTAL BONE'.light_green} shaped slot in the #{'ALTAR'.green} and give it a good few tippy tap whacks until it rotates just right, fixing itself to the slot. You hear one face of the #{'ALTAR'.green} open with a thud, revealing a small chamber housing a #{'KEY'.light_green}.",
                                    use_text_fail: "\nPerhaps something goes into the slot.",
                                    used_text: "\nThere is nothing more to do here except maybe salivated over the #{'CRYSTAL BONE'.light_green}, even though you know it's too hard to chew.",
                                    used?: false,
                                    use_effect: nil,
                                    accessible?: true,
                                    contains: 2}],
                monster?: true,
                monster_id: 0,
                monster_defeat?: false,
                visited?: false},

                {location_id: 2,
                location_name: "Crypt",
                move_locations: [{name: "Courtyard", 
                                id: 1,
                                open?: true}],
                intro_text: "You descend into the spooky crypt. It smells like dank and not in a good way. The stairs lead to a chamber lit by torches that just light themselves I guess. You no have time to think about the mechanics of a centralised, automatic torch refueling and ignition system because in the middle of the chamber you spot a #{'NOISY HOOVER'.red}!",
                look_text: "The #{'NOISY HOOVER'.red} dominates the unnaturally clean chamber with its stillness. Perhaps it is asleep? Either way, you must strike to save the land!",
                interactibles: nil,
                monster?: true,
                monster_id: 1,
                monster_defeat?: false,
                visited?: false}
                ]

    PLAYER_ATTR = {player_name: "",
                player_age: 0,
                player_location_id: nil,
                player_attack: 1..4,
                inventory: []}

    ITEM_LIST = [
                {name: "Letter",
                item_id: 0,
                examine_text: "\"FINAL NOTICE OF NON-PAYMENT!\" reads the letter. The rest is chewed up and illegiable. \nProbably by some other doge or maybe cat. Oh heck."},
                
                {name: "Crystal Bone", 
                item_id: 1,
                examine_text: "A heckin' huge sparkly, omnious bone that's far too made of crystal to chew on."},
            
                {name: "Key", 
                item_id: 2,
                examine_text: "A perfectly normal bone key with a not at all spooky skull motif in the handle. This is \nfine."}
                ]

    MON_LIST = [
                {name: "unreasonably large doge",
                monster_hp: 10,
                monster_hp_max: 10,
                monster_intro: "\nAn #{'UNREASONABLY LARGE DOGE'.red} blocks your path. He's just standing there with a dumb look on his face while being too big!", 
                monster_attack_text: "\nThe #{'UNREASONABLY LARGE DOGE'.red} stands over you imposingly and drools on you a little.",
                monster_defeat_text: "\nThe #{'UNREASONABLY LARGE DOGE'.red} finally notices your attacks, licks your face and goes to take a nap in the corner, revealing the #{'CRYPT DOOR'.green} behind it.",
                monster_defeat_effect: proc {Game::ROOM_ATTR[1][:interactibles][0][:accessible?] = true},
                loot: 1},

                {name: "noisy hoover", 
                monster_hp: 20,
                monster_hp_max: 20,
                monster_intro: "\nThe #{'NOISY HOOVER'.red} springs to life, whirring and undulating. You know it will not stop until everything is clean!", 
                monster_attack_text: "\nThe #{'NOISY HOOVER'.red} cleans the floor back and forth in front of you, evily.",
                monster_defeat_text: "\nThe #{'NOISY HOOVER'.red} splutters and then explodes dramatically. Do those things even have gasoline tanks? W-Wow, that's a lot of fire. Better get the heck out of here!",
                monster_defeat_effect: Proc.new {Game.final},
                loot: nil}
                ]

    # =========================
    # Final text sequence and end of game
    # =========================
    def self.final
        box = TTY::Box.frame(width: 100, height: 15, align: :center, padding: 3, border: :thick,
            title: {top_left: "|Dungeons of Heck|", bottom_right: "|Final|"}) do
                "You, #{PLAYER_ATTR[:player_name].upcase.yellow}, flee the flaming #{'CRYPT'.green} as smoke billows out from the entrance and between the ancient brickwork. With suprising speed, you seen the #{"HECK WIZARD".red} is giving chase and boy is he mad! \nLike the wind, out the #{'GATE'.green} you shoot and down the road. \nThe #{"HECK WIZARD".red} chases you for a little bit but turns around when he hears the fire engine coming down the road from the other direction. \nOne day you may return but for now you think you better lay low and content yourself with having rid the land of one more #{'NOISY HOOVER'.red}."
            end
        system('clear') || system('cls')
        puts box
        prompt.keypress("Press space or enter to fulfill your destiny!".green, keys: [:space, :return])
        exit
    end

    # =========================
    # Method for game menu loop
    # =========================
    def game_menu
        system('clear') || system('cls')
        box = TTY::Box.frame(width: 100, height: 13, align: :center, padding: [3,0], border: :thick,
            title: {top_left: "|Dungeons of Heck|", bottom_right: "|Location: #{ROOM_ATTR[PLAYER_ATTR[:player_location_id]][:location_name]}|"}) do
                if ROOM_ATTR[PLAYER_ATTR[:player_location_id]][:visited?]
                    ROOM_ATTR[PLAYER_ATTR[:player_location_id]][:look_text]
                else
                    ROOM_ATTR[PLAYER_ATTR[:player_location_id]][:intro_text]
                end
            end
        puts box
        ROOM_ATTR[PLAYER_ATTR[:player_location_id]][:visited?] = true

        prompt.select("Choose your FATE".red) do |menu|
            if ROOM_ATTR[PLAYER_ATTR[:player_location_id]][:monster?] && !ROOM_ATTR[PLAYER_ATTR[:player_location_id]][:monster_defeat?]
            menu.choice "Fight!", -> {Battle::fight; game_menu}
            end
            menu.choice "Move", -> {Action::move; game_menu}
            menu.choice "Use", -> {Action::use; game_menu}
            menu.choice "Inventory", -> {Action::bag; game_menu}
            menu.choice "Quit", -> {Action::exit_game}
        end
    end

    # =========================
    # Method for getting the player name and introducting the player to the game before starting the game_menu loop
    # =========================
    def introduction
        puts "\nHumble doge, what is your true name?".light_blue
        begin
            PLAYER_ATTR[:player_name] = gets.chomp.strip.upcase
        raise NotValidName if PLAYER_ATTR[:player_name].match?(/[^a-zA-Z]/) || PLAYER_ATTR[:player_name].length > 7 || PLAYER_ATTR[:player_name].length < 1 # Name must be letters and less than 8 characters
        rescue NotValidName => e
            puts e.message
            retry
        end

        puts "\nHumble doge, what is your true age?".light_blue
        begin
            PLAYER_ATTR[:player_age] = Integer(gets) rescue 0
        raise NotValidAge unless PLAYER_ATTR[:player_age] > 0
        rescue NotValidAge => e
            puts e.message
            retry
        end
        
        if PLAYER_ATTR[:player_age] > 15
            puts "\nWow, that's heckin' old for a doge but if you say so.".light_blue
        else
            puts "\n#{PLAYER_ATTR[:player_age]} is a fine age for a doge adventurer such as yourself.".light_blue
        end

        puts "\nMighty ".light_blue + "#{PLAYER_ATTR[:player_name].upcase.yellow}" + ", this is your tale.".light_blue

        box = TTY::Box.frame(width: 100, height: 15, align: :center, padding: 3, border: :thick,
            title: {top_left: "|Dungeons of Heck|", bottom_right: "|Introduction|"}) do
                "The cold wind blows harshly against your snoot. You lick it to keep it moist and glistening as you take in your surroundings. \nYou are #{PLAYER_ATTR[:player_name].upcase.yellow} and you are a #{'GOOD BOY'.green}. \nYou have travelled following rumours and tales of a heckin' evil place where #{'BAD DOGES'.red} and \n#{'NOISY APPLIANCES'.red} are said to lurk. You have tasked yourself with destroying heckin' bad things across the land and now you have arrived outside the grounds of an imposing castle said to be built upon the most heckin' place of all, the #{'DUNGEONS OF HECK'.red}."
            end

        prompt.keypress("Press space or enter to continue".green, keys: [:space, :return])
        system('clear') || system('cls')
        puts box

        prompt.keypress("Press space or enter to continue".green, keys: [:space, :return])
        PLAYER_ATTR[:player_location_id] = 0
        game_menu
    end

    # =========================
    # Method for the main menu when starting the game
    # =========================
    def main_menu
        system('clear') || system('cls')
        puts font.write("DUNGEONS OF HECK").red

        # acsii = File.open('doge.txt').read
        # acsii.each_line { |line| puts line }

        # puts ''
        prompt.select("Choose your FATE".red) do |menu|
            menu.choice "Start", -> {introduction}
            menu.choice "Quit", -> {exit}
        end
    end

end