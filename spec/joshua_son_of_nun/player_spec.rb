require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe JoshuaSonOfNun::Player do
  before do
    @model = JoshuaSonOfNun::Player.new
  end
  
  it "should know about it's ships" do
    @model.carrier.should_not be_nil
    @model.battleship.should_not be_nil
    @model.destroyer.should_not be_nil
    @model.submarine.should_not be_nil
    @model.patrolship.should_not be_nil
  end
  
  it "should have a game board" do
    @model.personal_board.should_not be_nil
    @model.opponent_board.should_not be_nil
  end
  
  it "should conform to the battleship API" do
    100.times do
      @model.next_target.should_not == ''
    end
    lambda {@model.target_result('A1', false, false)}.should_not raise_error
    lambda {@model.new_game('bob')}.should_not raise_error
    @model.carrier_placement.should_not be_nil
    @model.battleship_placement.should_not be_nil
    @model.destroyer_placement.should_not be_nil
    @model.submarine_placement.should_not be_nil
    @model.patrolship_placement.should_not be_nil
  end
end