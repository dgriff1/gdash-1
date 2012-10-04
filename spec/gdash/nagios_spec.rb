module GDash
  describe Nagios do
    TEXT = <<EOF
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

    subject do
      Nagios.new :some_host_group do |nagios|
        nagios.nagios_host = "http://nagios-server/nagios"
        nagios.nagios_username = "user"
        nagios.nagios_password = "passowrd"

        nagios.stub! :open => StringIO.new(TEXT)
      end
    end
    
    it "should be a Widget" do
      subject.should be_a Widget
    end
    
    describe :initialize do
      it "should take a host group" do
        Nagios.new(:some_host_group).host_group.should == "some_host_group"
      end

      it "should yield itself to the block" do
        yielded = nil
        dashboard = Nagios.new :some_host_group do |n|
          yielded = n
        end
        dashboard.should == yielded
      end
    end
    
    describe :host_group do
      it "should have accessors" do
        subject.host_group = :foo
        subject.host_group.should == :foo
      end
    end

    describe :description do
      it "should extract the name from the document" do
        subject.description.should == "Description of the Host Group"
      end

      it "should have accessors" do
        subject.description = :foo
        subject.description.should == :foo
      end
    end

    context :hosts do
      subject do
        Nagios.new(:some_host_group) do |nagios|
          nagios.nagios_host = "http://nagios-server/nagios"
          nagios.nagios_username = "user"
          nagios.nagios_password = "passowrd"

          nagios.stub! :open => StringIO.new(TEXT)
        end.hosts
      end

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

    context :services do
      subject do
        Nagios.new(:some_host_group) do |nagios|
          nagios.nagios_host = "http://nagios-server/nagios"
          nagios.nagios_username = "user"
          nagios.nagios_password = "passowrd"

          nagios.stub! :open => StringIO.new(TEXT)
        end.services
      end

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
  end
end