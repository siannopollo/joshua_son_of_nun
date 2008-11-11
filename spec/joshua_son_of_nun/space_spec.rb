require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe JoshuaSonOfNun::Board::Space do
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
end