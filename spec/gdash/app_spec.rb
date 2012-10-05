require "spec_helper"

GDash::Dashboard.new :foo do
end

GDash::Dashboard.new :bar do
end

module GDash
  describe App do
    include Rack::Test::Methods

    describe "Showing a dashboard" do
      describe "when :name is a defined dashbaord" do
        subject { get "/foo" }

        it { should be_ok }
        its(:body) { should =~ /#{Dashboard[:foo].to_html}/ }
      end
      
      describe :window do
        let!(:foo) { Window.define :foo }
        let!(:bar) { Window.define :bar }
        let(:dashboard) { Dashboard.new :foo }
        before { Dashboard.stub! :new => dashboard }
        
        it "looks up the window" do
          get "/foo?window=foo"
          dashboard.window.should == Window[:foo]
        end
        
        it "uses the default window if not specified" do
          get "/foo"
          dashboard.window.should == Window.default
        end
      end
    end

    describe "Documentation" do
      subject { get "/doc" }
      it { should be_redirect }
    end

    describe "Showing a help page" do
      describe "when :page exists" do
        before do
          File.open File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. doc foo.md})), "w" do |f|
            f.puts "# Test"
          end
        end
        after { File.unlink File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. doc foo.md})) }
        
        subject { get "/doc/foo" }

        it { should be_ok }
        its(:body) { should =~ /<h1>\s*Test\s*<\/h1>/m }
      end
    end
  end
end