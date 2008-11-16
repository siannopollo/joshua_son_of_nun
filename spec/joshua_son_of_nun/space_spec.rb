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
  
  it "should return the spaces for placement for a ship of given length" do
    Space('A1 horizontal').spaces_for_placement(4).should ==
      space_array('A1', 'A2', 'A3', 'A4')
    
    Space('A1 vertical').spaces_for_placement(5).should ==
      space_array('A1', 'B1', 'C1', 'D1', 'E1')
    
    Space('A8 horizontal').spaces_for_placement(5).should ==
      space_array('A8', 'A9', 'A10').concat([nil, nil])
  end
  
  it "should know which spaces are crosswise to the given space" do
    @model.crosswise_spaces.should == space_array('A2', 'B1')
    Space('C10').crosswise_spaces.should == space_array('B10', 'D10', 'C9')
    Space('E5').crosswise_spaces.should == space_array('D5', 'E6', 'F5', 'E4')
    Space('A7').crosswise_spaces.should == space_array('A8', 'B7', 'A6')
  end
  
  it "should know which spaces are in the diagonal of a given direction" do
    @model = Space('E5')
    @model.spaces_on_diagonal(:northeast).should == space_array('D6', 'C7', 'B8', 'A9')
    @model.spaces_on_diagonal(:southeast).should == space_array('F6', 'G7', 'H8', 'I9', 'J10')
    @model.spaces_on_diagonal(:southwest).should == space_array('F4', 'G3', 'H2', 'I1')
    @model.spaces_on_diagonal(:northwest).should == space_array('D4', 'C3', 'B2', 'A1')
  end
  
  it "should know which spaces are in an 'L' shape to the given square and direction" do
    @model.spaces_in_knighted_move(:northeast).should be_nil
    space_array('C2', 'B3').should include(@model.spaces_in_knighted_move(:southeast))
    @model.spaces_in_knighted_move(:southwest).should be_nil
    @model.spaces_in_knighted_move(:northwest).should be_nil
    
    @model = Space('E5')
    space_array('C6', 'D7').should include(@model.spaces_in_knighted_move(:northeast))
    space_array('G6', 'F7').should include(@model.spaces_in_knighted_move(:southeast))
    space_array('F3', 'G4').should include(@model.spaces_in_knighted_move(:southwest))
    space_array('D3', 'C4').should include(@model.spaces_in_knighted_move(:northwest))
  end
  
  it "should know which spaces are linear to two given spaces, and return the two immediate closest spaces" do
    Space('E6').linear_spaces(Space('E5')).should == space_array('E4', 'E7')
    Space('E5').linear_spaces(Space('D5')).should == space_array('C5', 'F5')
    @model.linear_spaces(Space('A2')).should == [Space('A3')]
    @model.linear_spaces(Space('B1')).should == [Space('C1')]
    
    Space('E6').linear_spaces(Space('E5'), [Space('E4')]).should == space_array('E3', 'E7')
    Space('E5').linear_spaces(Space('D5'), [Space('C5')]).should == space_array('B5', 'F5')
    Space('D1').linear_spaces(Space('B1'), space_array('A1', 'B1', 'C1', 'D1')).should == [Space('E1')]
  end
  
  def space_array(*coordinates)
    coordinates.collect {|c| Space(c)}
  end
end