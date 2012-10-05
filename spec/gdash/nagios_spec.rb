module GDash
  describe Nagios, :type => :request do
    let(:text) { <<EOF }
{"hostgroups": [{
   "hostgroup_name":"some_host_group",
	 "hostgroup_alias":"Description of the Host Group",
	 "hostgroup_host_totals": {
		 "hosts_up":2,
		 "hosts_down":0,
		 "hosts_unreachable":0,
		 "hosts_pending":0,
		 "hosts_unreachable_scheduled":0,
		 "hosts_unreachable_acknowledged":0,
		 "hosts_unreachable_disabled":0,
		 "hosts_unreachable_unacknowledged":0,
		 "hosts_down_scheduled":0,
		 "hosts_down_acknowledged":0,
		 "hosts_down_disabled":0,
		 "hosts_down_unacknowledged":0
	 },
   "hostgroup_service_totals": {
	   "services_ok":20,
		 "services_warning":0,
		 "services_unknown":0,
		 "services_critical":1,
		 "services_pending":0,
		 "services_warning_host_problem":0,
		 "services_warning_scheduled":0,
		 "services_warning_acknowledged":0,
		 "services_warning_disabled":0,
		 "services_warning_unacknowledged":0,
		 "services_unknown_host_problem":0,
		 "services_unknown_scheduled":0,
		 "services_unknown_acknowledged":0,
		 "services_unknown_disabled":0,
		 "services_unknown_unacknowledged":0,
		 "services_critical_host_problem":0,
		 "services_critical_scheduled":0,
		 "services_critical_acknowledged":0,
		 "services_critical_disabled":0,
		 "services_critical_unacknowledged":1
   }
	},
  {}]
}
EOF

    let :nagios do
      described_class.new :some_host_group do |nagios|
        nagios.nagios_host = "http://nagios-server/nagios"
        nagios.nagios_username = "user"
        nagios.nagios_password = "passowrd"

        nagios.stub! :open => StringIO.new(text)
      end
    end

    subject { nagios }
    
    it { should be_a Widget }
    
    its(:host_group) { should == "some_host_group" }
    its(:description) { should == "Description of the Host Group" }
    
    its(:nagios_host) { should == "http://nagios-server/nagios" }
    its(:nagios_username) { should == "user" }
    its(:nagios_password) { should == "passowrd" }

    describe "#hosts" do
      subject { nagios.hosts }
      
      its(:hosts_up) { should == 2 }
      its(:hosts_down) { should == 0 }
      its(:hosts_pending) { should == 0 }
      its(:hosts_unreachable) { should == 0 }
      its(:hosts_unreachable_scheduled) { should == 0 }
      its(:hosts_unreachable_acknowledged) { should == 0 }
      its(:hosts_unreachable_disabled) { should == 0 }
      its(:hosts_unreachable_unacknowledged) { should == 0 }
      its(:hosts_down_scheduled) { should == 0 }
      its(:hosts_down_acknowledged) { should == 0 }
      its(:hosts_down_disabled) { should == 0 }
      its(:hosts_down_unacknowledged) { should == 0 }
    end

    describe "#services" do
      subject { nagios.services }
      
      its(:services_ok) { should == 20 }
      its(:services_warning) { should == 0 }
      its(:services_unknown) { should == 0 }
      its(:services_critical) { should == 1 }
      its(:services_pending) { should == 0 }
      its(:services_warning_host_problem) { should == 0 }
      its(:services_warning_scheduled) { should == 0 }
      its(:services_warning_acknowledged) { should == 0 }
      its(:services_warning_disabled) { should == 0 }
      its(:services_warning_unacknowledged) { should == 0 }
      its(:services_unknown_host_problem) { should == 0 }
      its(:services_unknown_scheduled) { should == 0 }
      its(:services_unknown_acknowledged) { should == 0 }
      its(:services_unknown_disabled) { should == 0 }
      its(:services_unknown_unacknowledged) { should == 0 }
      its(:services_critical_host_problem) { should == 0 }
      its(:services_critical_scheduled) { should == 0 }
      its(:services_critical_acknowledged) { should == 0 }
      its(:services_critical_disabled) { should == 0 }
      its(:services_critical_unacknowledged) { should == 1 }
    end

    describe "#to_html" do
      subject { nagios.to_html }

      it { should have_selector "table.table" }
      
      it { should have_selector "span.badge.badge-success", :content => nagios.hosts.hosts_up }
      it { should have_content "Up" }

      it { should have_selector "span.badge.badge-success", :content => nagios.services.services_ok }
      it { should have_content "OK" }      
      
      it { should have_selector "span.badge.badge-important", :content => nagios.hosts.hosts_down }
      it { should have_content "Down" }
      
      it { should have_selector "span.badge.badge-important", :content => nagios.services.services_critical }
      it { should have_content "Critical" }
      
      it { should have_selector "span.badge.badge-warning", :content => nagios.hosts.hosts_unreachable }
      it { should have_content "Unreachable" }
      
      it { should have_selector "span.badge.badge-warning", :content => nagios.services.services_unknown }
      it { should have_content "Unknown" }
      
      it { should have_selector "span.badge.badge-info", :content => nagios.hosts.hosts_pending }
      it { should have_content "Pending" }
      
      it { should have_selector "span.badge.badge-info", :content => nagios.services.services_pending }
      it { should have_content "Pending" }
    end
  end
end