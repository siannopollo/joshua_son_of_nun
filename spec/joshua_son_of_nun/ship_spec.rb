require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Ships" do
  before do
    @board = JoshuaSonOfNun::Board.new
    @model = JoshuaSonOfNun::Battleship.new(@board)
  end
  
  it "should have a length" do
    @model.length.should == 4
  end
  
  it "should have an initial placement on the board" do
    @model.initial_placement.should_not be_nil
    @model.initial_placement.should =~ /[A-Z][0-9] [horizontal|vertical]/
  end
end