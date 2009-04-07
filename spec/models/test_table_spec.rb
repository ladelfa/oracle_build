require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TestTable do
  before(:each) do
    @valid_attributes = {
      :name => "Claire",
      :pet => "cat",
      :color_id => 2
    }
  end

  it "should create a new instance given valid attributes" do
    t = TestTable.create!(@valid_attributes)
    t.name.should == "Claire"
  end
  
  it "should raise an error attempting create an instance that violates a DB check constraint" do
    t = TestTable.new(@valid_attributes)
    t.pet = "wombat"
    lambda{t.save!}.should raise_error
  end
  
end
