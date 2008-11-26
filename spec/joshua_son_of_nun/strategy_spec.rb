require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe JoshuaSonOfNun::Strategy::Random do
  before do
    @board = JoshuaSonOfNun::Board.new
    @model = JoshuaSonOfNun::Strategy::Random.new(@board)
  end
  
  it "should target all spaces" do
    @model.targets.uniq.size.should == 100
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
    target = @model.targets.delete(Space('E5'))
    @model.instance_variable_set '@current_target', target
    @model.register_result! true, false
    
    @model.next_target.should == Space('D5') # First crosswise space to attack
    @model.next_target.should == Space('E6')
    @model.next_target.should == Space('F5')
    @model.next_target.should == Space('E4')
  end
  
  it "should not target differently if nothing was hit" do
    target = @model.targets.delete(Space('E5'))
    @model.instance_variable_set '@current_target', target
    next_target = @model.targets.first
    @model.register_result! false, false
    
    @model.next_target.should == next_target
  end
  
  it "should target in a line if two or more targets have been hit" do
    @model.instance_variable_set '@immediate_targets', [Space('E5')]
    @model.next_target; @model.register_result! true, false # first shot
    
    @model.instance_variable_set '@immediate_targets', [Space('E6')]
    @model.next_target; @model.register_result! true, false # second shot
    
    @model.next_target.should == Space('E4')
    @model.register_result! false, false
    
    @model.next_target.should == Space('E7')
    @model.register_result! true, false
    
    @model.next_target.should == Space('E8')
  end
  
  it "should track successful targets" do
    target_one = @model.next_target
    @model.register_result! true, false
    
    target_two = @model.next_target
    @model.register_result! true, false
    
    @model.successful_targets.should == [target_one, target_two]
  end
end

describe JoshuaSonOfNun::Strategy::Diagonal do
  before do
    JoshuaSonOfNun::Space.stub!(:directions).and_return([:southeast])
    
    @board = JoshuaSonOfNun::Board.new
    @model = JoshuaSonOfNun::Strategy::Diagonal.new(@board)
  end
  
  it "should target all spaces" do
    @model.targets.uniq.size.should == 100
  end
  
  it "should search across the board in a diagonal fashion" do
    target = Space('E5')
    expected_next_target = Space('F6')
    
    if @model.targets.index(target) < @model.targets.index(expected_next_target)
      @model.targets[@model.targets.index(target) + 1].should == expected_next_target
    else
      @model.targets[@model.targets.index(expected_next_target) + 1].should == Space('G7')
    end
  end
end

describe JoshuaSonOfNun::Strategy::Knight do
  before do
    JoshuaSonOfNun::Space.stub!(:directions).and_return([:southeast])
    
    @board = JoshuaSonOfNun::Board.new
    @model = JoshuaSonOfNun::Strategy::Knight.new(@board)
  end
  
  it "should target all spaces" do
    @model.targets.uniq.size.should == 100
    # The specifics of this strategy are not tested here because the next move
    # from space E5 may have already been placed in the targeting array,
    # making the order very difficult to test since sometimes the test will
    # pass, other times the test will fail. So, testing whether or not we have
    # all the targets is good enough.
    # 
    # Also, moving like a knight is tested in the space_spec
  end
end