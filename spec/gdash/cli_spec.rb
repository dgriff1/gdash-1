require "spec_helper"

module GDash
  describe Cli do
    after { FileUtils.rm_rf File.expand_path("tmp", File.dirname(__FILE__)) }

    let(:cli) { Cli.new }
    subject { cli }

    it { should be_a Thor }
    it { should be_a Thor::Actions }

    describe "new PATH" do
      before { cli.new File.expand_path("tmp", File.dirname(__FILE__)) }

      subject { File }

      it { should be_exist File.expand_path("tmp/Dashfile", File.dirname(__FILE__)) }
      it { should be_exist File.expand_path("tmp/dashboards.rb", File.dirname(__FILE__)) }
      it { should be_exist File.expand_path("tmp/config.ru", File.dirname(__FILE__)) }
    end

    describe "server" do
      # TBD
    end
  end
end