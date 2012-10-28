require "spec_helper"

describe GDash do
  describe ".config" do
    let :config do
      GDash.config do |config|
        config.dashboards = "foo/bar.rb"
      end
    end

    subject { config }

    it { should be_a GDash::Configuration }
    it { should == GDash.config }
    its(:dashboards) { should == "foo/bar.rb" }
  end
end