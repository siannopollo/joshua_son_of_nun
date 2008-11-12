require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe JoshuaSonOfNun::Strategy::Random do
  before do
    @board = JoshuaSonOfNun::Board.new
    @model = JoshuaSonOfNun::Strategy::Random.new(@board)
  end
  
  it "should target all spaces" do
    @model.targets.size.should == 100
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
    targets = @model.targets.dup
    @model.instance_variable_set '@current_target', target
    @model.instance_variable_get('@expended_targets') << target
    @model.register_result! true, false
    
    @model.targets.size.should == 99
    @model.targets.should_not == targets
    @model.old_targets.should == targets
    @model.targets[0..3].should == [Space('D5'), Space('E6'), Space('F5'), Space('E4')]
  end
  
  it "should not target differently if nothing was hit" do
    target = @model.targets.delete(Space('E5'))
    targets = @model.targets
    @model.instance_variable_set '@current_target', target
    @model.register_result! false, false
    
    @model.targets.should == targets
  end
  
  it "should restore the old target array minus the shots taken if the ship was sunk" do
    target = @model.targets.delete(Space('E5'))
    targets = @model.targets.dup
    @model.instance_variable_set '@current_target', target
    @model.instance_variable_get('@expended_targets') << target
    @model.register_result! true, false
    
    sinking_target = @model.next_target
    @model.register_result! true, true
    targets.delete(sinking_target) # get old target array in the proper state
    
    @model.targets.size.should == targets.size
    @model.targets.should == targets
  end
end

describe JoshuaSonOfNun::Strategy::Diagonal do
  before do
    JoshuaSonOfNun::Space.stub!(:directions).and_return([:southeast])
    
    @board = JoshuaSonOfNun::Board.new
    @model = JoshuaSonOfNun::Strategy::Diagonal.new(@board)
  end
  
  it "should target all spaces" do
    @model.targets.size.should == 100
  end
  
  it "should search across the board in a diagonal fashion" do
    target = @model.targets.find {|t| t == Space('E5')}
    @model.targets[@model.targets.index(target) + 1].should == Space('F6')
  end
end

describe JoshuaSonOfNun::Strategy::Knight do
  before do
    @board = JoshuaSonOfNun::Board.new
    @model = JoshuaSonOfNun::Strategy::Knight.new(@board)
  end
  
  it "should target all spaces" do
    @model.targets.size.should == 100
  end
  
  it "should search across the board like a knight in chess" do
    
  end
  # 
  # it "should search across the board in a diagonal fashion" do
  #   JoshuaSonOfNun::Space.stub!(:directions).and_return([:southeast])
  #   @model = JoshuaSonOfNun::Strategy::Diagonal.new(@board)
  #   
  #   first_target = @model.targets.first
  #   diagonal_targets = first_target.spaces_on_diagonal(:southeast)
  #   @model.targets[1].should == diagonal_targets[0] unless diagonal_targets.empty?
  # end
end