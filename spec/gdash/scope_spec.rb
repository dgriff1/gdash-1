require "spec_helper"

module GDash
  describe Scope do
    let(:parent) { Scope.new nil, :foo => :bar, :baz => :quux}
    let(:child) { Scope.new parent, :foo => :asdf }

    context "parent scope" do
      subject { parent }

      its(:foo) { should == :bar }
      its(:baz) { should == :quux }
    end

    context "child scope" do
      subject { child }

      its(:foo) { should == :asdf }
      its(:baz) { should == :quux }
    end
  end
end