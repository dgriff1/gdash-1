require "spec_helper"

module GDash
  describe Doc do
    before do
      File.open Doc.new(:test_doc).path, "w" do |f|
        f.puts "# Test Doc"
      end
    end

    after { FileUtils.rm_f Doc.new(:test_doc).path }
    subject { described_class.new :test_doc }

    its(:name) { should == :test_doc }
    its(:path) { should == "#{described_class::DIR}/test_doc.md" }
    its(:title) { should == "Test Doc" }
    its(:to_html) { should =~ /<h1>Test Doc<\/h1>/ }

    describe "::DIR" do
      subject { described_class }
      it { should be_const_defined "DIR" }
    end

    describe ".[]" do
      it "returns a doc of that name" do
        described_class[:test_doc].should == described_class.new(:test_doc)
      end
    end

    describe ".each" do
      it "yields each doc to the block" do
        docs = []
        described_class.each do |doc|
          docs << doc
        end
        docs.map(&:name).should be_include "test_doc"
      end
    end

    describe "#initialize" do
      it "takes a name" do
        expect { described_class.new }.to raise_error ArgumentError
      end
    end
    
    describe "#==" do
      let(:foo_one) { described_class.new :foo }
      let(:foo_two) { described_class.new :foo }
      let(:bar) { described_class.new :bar }
      
      subject { foo_one }
      
      it { should == foo_two }
      it { should_not == bar }
    end

    describe "#<=>" do
      let(:foo) { described_class.new :foo }
      let(:bar) { described_class.new :bar }

      it "compares on title" do
        [foo, bar].sort.should == [bar, foo]
      end
    end
  end
end