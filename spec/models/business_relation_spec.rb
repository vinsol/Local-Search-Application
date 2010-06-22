require 'spec_helper'

describe BusinessRelation do
  fixtures :members, :businesses, :business_relations
  it "should have a member" do
    @business_relation = BusinessRelation.find(business_relations(:one))
    @business_relation.member.id.should_not == nil
  end
end
