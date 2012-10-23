require "spec_helper"

module GDash
  describe DataCenter do
    let :data_center do
      DataCenter.define :foo, :title => "Foo Data Center" do |data_center|
        data_center.prefix = "asdf"
        data_center.ganglia_host = "http://ganglia"
        data_center.graphite_host = "http://graphite"
        data_center.cacti_host = "http://cacti"
        data_center.nagios_host = "http://nagios"
        data_center.nagios_username = "nagios_username"
        data_center.nagios_password = "nagios_password"
      end
    end

    subject { data_center }

    it { should be_a DataCenter }
    its(:name) { should == "foo" }
    its(:title) { should == "Foo Data Center" }
    its(:prefix) { should == "asdf" }

    its(:ganglia_host) { should == "http://ganglia" }
    its(:graphite_host) { should == "http://graphite" }
    its(:cacti_host) { should == "http://cacti" }
    its(:nagios_host) { should == "http://nagios" }
    its(:nagios_username) { should == "nagios_username" }
    its(:nagios_password) { should == "nagios_password" }

    describe ".[]" do
      subject { DataCenter[:foo] }
      it { should == data_center }
    end
  end
end