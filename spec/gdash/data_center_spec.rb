require "spec_helper"

module GDash
  describe DataCenter do
    let! :data_center do
      GDash.data_center :foo, :title => "Foo Data Center" do
        prefix "asdf"
        ganglia_host "http://ganglia"
        graphite_host "http://graphite"
        cacti_host "http://cacti"
        nagios_host "http://nagios"
        nagios_username "nagios_username"
        nagios_password "nagios_password"
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

    describe ".all" do
      subject { DataCenter.all }
      it { should == [data_center] }
    end
  end
end