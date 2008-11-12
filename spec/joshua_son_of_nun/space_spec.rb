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
  
  it "should know which spaces are in the diagonal of a given direction" do
    @model = Space('E5')
    @model.spaces_on_diagonal(:northeast).should == ['D6', 'C7', 'B8', 'A9'].collect {|s| Space(s)}
    @model.spaces_on_diagonal(:southeast).should == ['F6', 'G7', 'H8', 'I9', 'J10'].collect {|s| Space(s)}
    @model.spaces_on_diagonal(:southwest).should == ['F4', 'G3', 'H2', 'I1'].collect {|s| Space(s)}
    @model.spaces_on_diagonal(:northwest).should == ['D4', 'C3', 'B2', 'A1'].collect {|s| Space(s)}
  end
  
  it "should know which spaces are in an 'L' shape to the given square and direction" do
    @model.spaces_in_knighted_move(:northeast).should be_nil
    [Space('C2'), Space('B3')].should include(@model.spaces_in_knighted_move(:southeast))
    @model.spaces_in_knighted_move(:southwest).should be_nil
    @model.spaces_in_knighted_move(:northwest).should be_nil
    
    @model = Space('E5')
    [Space('C6'), Space('D7')].should include(@model.spaces_in_knighted_move(:northeast))
    [Space('G6'), Space('F7')].should include(@model.spaces_in_knighted_move(:southeast))
    [Space('F3'), Space('G4')].should include(@model.spaces_in_knighted_move(:southwest))
    [Space('D3'), Space('C4')].should include(@model.spaces_in_knighted_move(:northwest))
  end
  
  it "should work as expected in an array" do
    pending
    array_one = ['A1', 'B2', 'C3'].collect {|s| Space(s)}
    array_two = ['A1', 'C3'].collect {|s| Space(s)}
    (array_one - array_two).should == [Space('B2')]
    (array_one & array_two).should == [Space('A1'), Space('C3')]
  end
end