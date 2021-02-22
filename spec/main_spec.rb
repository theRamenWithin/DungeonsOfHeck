require_relative '../lib/main'

# Tests that user name input during the Game::introduction loop is correctly error handled
describe 'introduction name' do
    it 'should raise an error for invalid input' do
        Game::PLAYER_ATTR[:player_name] = "123"
        expect {raise NotValidName if Game::PLAYER_ATTR[:player_name].match?(/[^a-zA-Z]/) || Game::PLAYER_ATTR[:player_name].length > 7}.to raise_error(NotValidName)
    end
    it 'should not raise an error for valid input' do
        Game::PLAYER_ATTR[:player_name] = "ALEX"
        expect {raise NotValidName if Game::PLAYER_ATTR[:player_name].match?(/[^a-zA-Z]/) || Game::PLAYER_ATTR[:player_name].length > 7}.to_not raise_error(NotValidName)
    end
end

# Tests that user age input during the Game::introduction loop is correctly error handled
describe 'introduction age' do
    it 'should raise an error for invalid input' do
        Game::PLAYER_ATTR[:player_age] = Integer("ALEX") rescue 0
        expect {raise NotValidAge unless Game::PLAYER_ATTR[:player_age] > 0}.to raise_error(NotValidAge)
    end
    it 'should not raise an error for valid input' do
        Game::PLAYER_ATTR[:player_age] = Integer(123) rescue 0
        expect {raise NotValidAge unless Game::PLAYER_ATTR[:player_age] > 0}.to_not raise_error(NotValidAge)
    end
end