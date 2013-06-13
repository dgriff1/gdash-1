require "spec_helper"

module GDash
  describe Tab do
    let :tab do
      Tab.define :foo do
        title "The Foo Tab"
      end
    end

    subject { tab }

    it { should be_a Page }
  end
end