require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe JoshuaSonOfNun::Player do
  before do
    @model = JoshuaSonOfNun::Player.new
  end
  
  it "should conform to the battleship API" do
    @model.carrier_placement.should_not be_nil
    @model.battleship_placement.should_not be_nil
    @model.destroyer_placement.should_not be_nil
    @model.submarine_placement.should_not be_nil
    @model.patrolship_placement.should_not be_nil
    
    100.times do
      @model.next_target.should_not == ''
    end
    
    lambda {@model.target_result('A1', false, false)}.should_not raise_error
    lambda {@model.new_game('bob')}.should_not raise_error
  end
end