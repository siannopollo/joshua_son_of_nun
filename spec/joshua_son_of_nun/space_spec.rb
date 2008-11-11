require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe JoshuaSonOfNun::Space do
  before do
    @model = Space('A1')
  end
  
  it "should know which spaces are close to other spaces" do
    @model.adjacent?(Space('A1')).should be_true
    @model.adjacent?(Space('A2')).should be_true
    @model.adjacent?(Space('B1')).should be_true
    @model.adjacent?(Space('B2')).should be_true
    Space('E5').adjacent?(Space('D6')).should be_true
    
    @model.adjacent?(Space('A10')).should be_false
    @model.adjacent?(Space('C3')).should be_false
    Space('H7').adjacent?(Space('J7')).should be_false
  end
  
  it "should know which spaces are crosswise to the given space" do
    @model.crosswise_spaces.should == [Space('A2'), Space('B1')]
    Space('C10').crosswise_spaces.should == [Space('B10'), Space('D10'), Space('C9')]
    Space('E5').crosswise_spaces.should == [Space('D5'), Space('E6'), Space('F5'), Space('E4')]
  end
  
  it "should work as expected in an array" do
    pending
    array_one = ['A1', 'B2', 'C3'].collect {|s| Space(s)}
    array_two = ['A1', 'C3'].collect {|s| Space(s)}
    (array_one - array_two).should == [Space('B2')]
    (array_one & array_two).should == [Space('A1'), Space('C3')]
  end
end