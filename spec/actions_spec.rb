require_relative '../lib/main'
require_relative '../lib/actions'

# Test whether the Action::bag method outputs correctly based on item or no item input
describe 'bag contents' do
    it 'should puts text to indicate that the bag is not empty' do
        Game::PLAYER_ATTR[:inventory] = [{name: "Name", examine_text: "Examine"}]
        expect{Action::bag_contents}.to output("┌────┬───────────┐\n│    │           │\n│Item│Description│\n│    │           │\n├────┼───────────┤\n│    │           │\n│\e[0;92;49mName\e[0m│Examine    │\n│    │           │\n└────┴───────────┘\n").to_stdout
    end

    it 'should puts text to indicate that the bag is empty' do
        Game::PLAYER_ATTR[:inventory] = []
        expect {Action::bag_contents}.to output("\nYour bag is empty. You shake the bag in your mouth sadly.\n").to_stdout
    end

end