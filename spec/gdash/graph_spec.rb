require "spec_helper"

module GDash
  describe Graph do
    subject do
      Graph.new
    end

    it "should be a Ganglia widget" do
      subject.should be_a Ganglia
    end
  end
end