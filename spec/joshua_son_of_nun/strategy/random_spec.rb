require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe JoshuaSonOfNun::Strategy::Random do
  before do
    @board = JoshuaSonOfNun::Board.new
    @model = JoshuaSonOfNun::Strategy::Random.new(@board)
  end
  
  it "should target all spaces" do
    (@model.targets & @board.valid_spaces).size.should == 100
  end
  
  it "should shift targets out of the array to gather targets" do
    target = nil
    lambda do
      @model.next_target
      @model.next_target
      target = @model.next_target
    end.should change(@model.targets, :size).by(-3)
    @model.current_target.should == target
  end
  
  it "should receive results of the current target, and react accordingly" do
    pending
    target = @model.targets.delete(Space('E5'))
    targets = @model.targets
    @model.instance_variable_set '@current_target', target
    @model.register_result! true, false
    
    @model.targets.size.should == 99
    @model.targets.should_not == targets
    @model.targets[0..3].should == [Space('D5'), Space('E6'), Space('F5'), Space('E4')]
  end
  
  it "should not target differently if nothing was hit" do
    target = @model.targets.delete(Space('E5'))
    targets = @model.targets
    @model.instance_variable_set '@current_target', target
    @model.register_result! false, false
    
    @model.targets.should == targets
  end
  
  it "should restore the old target array minus the shots taken if the ship was sunk"
end