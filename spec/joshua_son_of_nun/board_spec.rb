require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe JoshuaSonOfNun::Board do
  before do
    @model = JoshuaSonOfNun::Board.new
  end
  
  it "should know about which spaces are valid" do
    @model.valid_spaces.should include(Space('A1'))
    @model.valid_spaces.should include(Space('A10'))
  end
  
  it "should calculate whether it can accomodate a ship at a certain space" do
    @model.accomodate?(Space('A1 horizontal'), 5).should be_true
    @model.accomodate?(Space('A10 horizontal'), 5).should be_false
    @model.accomodate?(Space('H1 vertical'), 3).should be_true
    @model.accomodate?(Space('H1 vertical'), 4).should be_false
  end
  
  it "should keep track of it's occupied spaces" do
    @model.placement(4)
    @model.occupied_spaces.size.should == 4
    
    @model.placement(5)
    @model.occupied_spaces.size.should == 9
  end
  
  it "should be able to tell if a space is adjacent to the occupied spaces" do
    space = Space('D3 horizontal')
    @model.occupied_spaces.concat(space.spaces_for_placement(5)) # D3, D4, D5, D6, D7
    
    @model.adjacent_to_occupied_spaces?(Space('C3 horizontal'), 5).should be_true
    @model.adjacent_to_occupied_spaces?(Space('E3 horizontal'), 5).should be_true
    @model.adjacent_to_occupied_spaces?(Space('E3 vertical'), 2).should be_true
    @model.adjacent_to_occupied_spaces?(Space('C8 vertical'), 2).should be_true
    @model.adjacent_to_occupied_spaces?(Space('E2 vertical'), 2).should be_true
    
    @model.adjacent_to_occupied_spaces?(Space('A1 horizontal'), 5).should be_false
    @model.adjacent_to_occupied_spaces?(Space('A1 vertical'), 5).should be_false
    @model.adjacent_to_occupied_spaces?(Space('A4 vertical'), 2).should be_false
    @model.adjacent_to_occupied_spaces?(Space('C9 vertical'), 5).should be_false
  end
end