require "spec_helper"

module GDash
  describe Configuration do
    let :configuration do
      Configuration.new do |config|
        config.dashboards = "foo/bar.rb"
      end
    end

    subject { configuration }

    its(:dashboards) { should == "foo/bar.rb" }
  end
end