require "spec_helper"

module GDash
  describe Report do
    subject do
      Report.new
    end

    it "should be a Ganglia widget" do
      subject.should be_a Ganglia
    end
  end
end