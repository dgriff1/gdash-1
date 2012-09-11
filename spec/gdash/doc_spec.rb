require "spec_helper"

module GDash
  describe Doc do
    before do
      File.open Doc.new(:test_doc).path, "w" do |f|
        f.puts "# Test Doc"
      end
    end

    subject do
      Doc.new :test_doc
    end

    after do
      File.unlink Doc.new(:test_doc).path
    end

    describe :[] do
      it "should return a doc of that name" do
        Doc[:test_doc].should == Doc.new(:test_doc)
      end
    end

    describe :each do
      it "should yield each doc to the block" do
        docs = []
        Doc.each do |doc|
          docs << doc
        end
        STDERR.puts "docs #=> #{docs.map(&:name).inspect}"
        docs.map(&:name).include?("test_doc").should be_true
      end
    end

    describe :initialize do
      it "should take a name" do
        Doc.new(:foo).name.should == :foo
      end
    end

    describe :DIR do
      it "should exist" do
        Doc::DIR.should_not be_empty
      end
    end

    describe :path do
      it "should be DIR/<name>.md" do
        subject.path.should == "#{Doc::DIR}/#{subject.name}.md"
      end
    end

    describe :title do
      it "should be the titleized name" do
        subject.title.should == subject.name.to_s.titleize
      end
    end

    describe :to_html do
      it "should render markdown" do
        subject.to_html.should =~ /<h1>Test Doc<\/h1>/
      end
    end

    describe :<=> do
      it "should compare on title" do
        foo = Doc.new :foo
        bar = Doc.new :bar
        [foo, bar].sort.should == [bar, foo]
      end
    end
  end
end