require "spec_helper"

module GDash
  module Data
    describe Set do
      let(:set) { Set.new }

      subject { set }

      its(:all) { should be_empty }

      describe :initialize do
        let(:point) { Point.new 1, DateTime.now }
        let(:set) { ::Set.new [point] }
        subject { Set.new set }
        its(:all) { should == ::Set.new([point]) }
      end

      describe :<< do
        let(:point) { Point.new 42, DateTime.now }
        before { set << point }
        its(:all) { should == ::Set.new([point]) }
      end

      describe :tagged do
        let(:foo) { Point.new 1, DateTime.now, :tags => :foo }
        let(:bar) { Point.new 2, DateTime.now, :tags => :bar }
        let(:foobar) { Point.new 3, DateTime.now, :tags => [:foo, :bar] }
        before { set << foo << bar << foobar }

        context "with foo" do
          subject { set.tagged(:foo) }
          it { should be_a Set }
          it { should_not == set }
          its(:all) { should == ::Set.new([foo, foobar]) }
        end

        context "with bar" do
          subject { set.tagged(:bar) }
          it { should be_a Set }
          it { should_not == set }
          its(:all) { should == ::Set.new([bar, foobar]) }
        end

        context "with foo or bar" do
          subject { set.tagged(:foo, :bar) }
          it { should be_a Set }
          it { should_not == set }
          its(:all) { should == ::Set.new([foo, bar, foobar]) }
        end

        context "with foo and bar" do
          subject { set.tagged(:foo).tagged(:bar) }
          it { should be_a Set }
          it { should_not == set }
          its(:all) { should == ::Set.new([foobar]) }
        end

        context "with a regular expressions" do
          let(:a) { Point.new 1, DateTime.now, :tags => :a }
          before { set << a }
          subject { set.tagged /a/ }
          it { should be_a Set }
          it { should_not == set }
          its(:all) { should == ::Set.new([bar, foobar, a]) }
        end
      end

      describe :before do
        let(:one) { Point.new 1, 1.week.ago }
        let(:two) { Point.new 2, 1.day.ago }
        before { set << one << two }

        context "today" do
          subject { set.before DateTime.now }
          its(:all) { should == ::Set.new([one, two]) }
        end

        context "two days ago" do
          subject { set.before 2.days.ago }
          its(:all) { should == ::Set.new([one]) }
        end
      end

      describe :after do
        let(:one) { Point.new 1, 6.days.ago }
        let(:two) { Point.new 2, 12.hours.ago }
        before { set << one << two }

        context "one week ago" do
          subject { set.after 1.week.ago }
          its(:all) { should == ::Set.new([one, two]) }
        end

        context "yesterday" do
          subject { set.after 1.day.ago }
          its(:all) { should == ::Set.new([two]) }
        end
      end

      describe :window do
        let(:one) { Point.new 1, 6.days.ago }
        let(:two) { Point.new 2, 3.days.ago }
        let(:three) { Point.new 3, 1.day.ago }
        before { set << one << two << three }

        context "start 4 days ago and last 2 days" do
          subject { set.window(4.days.ago, 2.days) }
          its(:all) { should == ::Set.new([two]) }
        end
      end

      describe :last do
        let(:one) { Point.new 1, 30.seconds.ago }
        let(:two) { Point.new 2, 3.minutes.ago }
        let(:three) { Point.new 3, 45.minutes.ago }
        let(:four) { Point.new 4, 1.minute.from_now }
        before { set << one << two << three << four }

        context "minute" do
          subject { set.last 1.minute }
          its(:all) { should == ::Set.new([one]) }
        end

        context "five minutes" do
          subject { set.last 5.minutes }
          its(:all) { should == ::Set.new([one, two]) }
        end

        context "hour" do
          subject { set.last 1.hour }
          its(:all) { should == ::Set.new([one, two, three]) }
        end
      end
    end
  end
end