require "spec_helper"

module GDash
  module Data
    describe Point do
      let(:timestamp) { DateTime.parse("2012-01-01 00:00:00") }
      let(:point) { Point.new 42, timestamp, :tags => [:foo, :bar] }

      subject { point }

      its(:datum) { should == 42 }
      its(:timestamp) { should == timestamp }
      its(:tags) { should == ["foo", "bar"] }

      context "with a single tag" do
        let(:point) { Point.new 42, timestamp, :tags => :foo }
        its(:tags) { should == ["foo"] }
      end

      describe :tagged? do
        it { should be_tagged :foo }
        it { should_not be_tagged :baz }
      end

      describe :tag do
        before { point.tag :quux }
        it { should be_tagged :quux }
      end

      describe :to_hash do
        subject { point.to_hash }
        its([:datum]) { should == 42 }
        its([:timestamp]) { should == timestamp }
      end
    end
  end
end