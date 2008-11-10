require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe JoshuaSonOfNun::Board do
  before do
    @model = JoshuaSonOfNun::Board.new
  end
  
  it "should have a width and height" do
    @model.width.should == 10
    @model.height.should == 10
  end
  
  it "should know about which spaces are valid" do
    @model.valid_spaces.should include('A1')
    @model.valid_spaces.should include('A10')
    @model.valid_spaces.should_not include('A11')
  end
  
  it "should be able to convert numeric coordinates to board coordinates" do
    @model.coordinates(1,1).should == 'A1'
    @model.coordinates(3,4).should == 'D3'
    @model.coordinates(10,10).should == 'J10'
  end
  
  it "should return the spaces for placement for a ship of given length" do
    @model.spaces_for_placement('A1 horizontal', 4).should == ['A1', 'A2', 'A3', 'A4']
    @model.spaces_for_placement('A1 vertical', 5).should == ['A1', 'B1', 'C1', 'D1', 'E1']
    @model.spaces_for_placement('A8 horizontal', 5).should == ['A8', 'A9', 'A10', 'A', 'A']
  end
  
  it "should calculate whether it can accomodate a ship at a certain space" do
    @model.accomodate?('A1 horizontal', 5).should be_true
    @model.accomodate?('A10 horizontal', 5).should be_false
    @model.accomodate?('H1 vertical', 3).should be_true
    @model.accomodate?('H1 vertical', 4).should be_false
  end
  
  it "should keep track of it's occupied spaces" do
    @model.placement(4)
    @model.occupied_spaces.size.should == 4
    
    @model.placement(5)
    @model.occupied_spaces.size.should == 9
  end
end