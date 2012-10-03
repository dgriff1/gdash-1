module GDash
  describe Nagios do
    before do
      subject.stub!(:open).and_return <<EOF
<html>
<head>
<link rel="shortcut icon" href="/nagios/images/favicon.ico" type="image/ico">
<title>
Current Network Status
</title>
<LINK REL='stylesheet' TYPE='text/css' HREF='/nagios/stylesheets/common.css'><LINK REL='stylesheet' TYPE='text/css' HREF='/nagios/stylesheets/status.css'></head>
<body CLASS='status'>

<!-- Produced by Nagios (http://www.nagios.org).  Copyright (c) 1999-2007 Ethan Galstad. -->
<P>
<table border=0 width=100%>
<tr>
<td valign=top align=left width=33%>
</td><td valign=top align=center width=33%>
<DIV ALIGN=CENTER CLASS='statusTitle'>Status Summary For Host Group 'rust-servers'</DIV>
<br></td>
<td valign=top align=right width=33%></td>
</tr>
</table>
</P>
<DIV ALIGN=center>
<table border=1 CLASS='status'>
<TR>
<TH CLASS='status'>Host Group</TH><TH CLASS='status'>Host Status Summary</TH><TH CLASS='status'>Service Status Summary</TH>
</TR>
<TR CLASS='statusEven'><TD CLASS='statusEven'>
<A HREF='status.cgi?hostgroup=rust-servers&style=overview'>System Engineering RUST Servers</A> (<A HREF='extinfo.cgi?type=5&hostgroup=rust-servers'>rust-servers</a>)</TD><TD CLASS='statusEven' ALIGN=CENTER VALIGN=CENTER><TABLE BORDER='0'>
<TR><TD CLASS='miniStatusUP'><A HREF='status.cgi?hostgroup=rust-servers&style=hostdetail&&hoststatustypes=2&hostprops=0'>2 UP</A></TD></TR>
<TR>
<TD CLASS='miniStatusDOWN'><TABLE BORDER='0'>
<TR>
<TD CLASS='miniStatusDOWN'><A HREF='status.cgi?hostgroup=perftest-servers&style=hostdetail&hoststatustypes=4&hostprops=0'>1 DOWN</A>&nbsp;:</TD>
<TD><TABLE BORDER='0'>
<tr><td width=100% class='hostImportantProblem'><a href='status.cgi?hostgroup=perftest-servers&style=hostdetail&hoststatustypes=4&hostprops=42'>1 Unhandled</a></td></tr>
</TABLE></TD>
</TR>
</TABLE></TD>
</TR>
</TABLE>
</TD><TD CLASS='statusEven' ALIGN=CENTER VALIGN=CENTER><TABLE BORDER=0>
<TR><TD CLASS='miniStatusOK'><A HREF='status.cgi?hostgroup=rust-servers&style=detail&&servicestatustypes=2&hoststatustypes=15&serviceprops=0&hostprops=0'>20 OK</A></TD></TR>
<TR>
<TD CLASS='miniStatusCRITICAL'><TABLE BORDER='0'>
<TR>
<TD CLASS='miniStatusCRITICAL'><A HREF='status.cgi?hostgroup=rust-servers&style=detail&servicestatustypes=16&hoststatustypes=15&serviceprops=0&hostprops=0'>1 CRITICAL</A>&nbsp;:</TD>
<TD><TABLE BORDER='0'>
<tr><td width=100% class='serviceImportantProblem'><a href='status.cgi?hostgroup=rust-servers&style=detail&servicestatustypes=16&hoststatustypes=3&serviceprops=42'>1 Unhandled</a></td></tr>
</TABLE></TD>
</TR>
</TABLE></TD>
</TR>
</TABLE>
</TD></TR>
</TABLE>
</DIV>

<!-- Produced by Nagios (http://www.nagios.org).  Copyright (c) 1999-2007 Ethan Galstad. -->
</body>
</html>
EOF
    end
    
    subject do
      Nagios.new :some_host_group
    end
    
    it "should be a Widget" do
      subject.should be_a Widget
    end
    
    describe :initialize do
      it "should take a host group" do
        Nagios.new(:some_host_group).host_group.should == :some_host_group
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
    
    describe :username do
      it "should have accessors" do
        subject.username = :foo
        subject.username.should == :foo
      end
    end
    
    describe :password do
      it "should have accessors" do
        subject.password = :foo
        subject.password.should == :foo
      end
    end
    
    describe :name do
      it "should extract the name from the document" do
        subject.name.should == "System Engineering RUST Servers"
      end
    end
    
    describe :hosts_up do
      it "should extract the number of hosts up" do
        subject.hosts_up.should == 2
      end
    end
    
    describe :hosts_down do
      pending "should extract the number of hosts down" do
      end
    end
    
    describe :hosts_unhandled do
      pending "should extract the number of unhandled hosts down" do
      end
    end
    
    describe :ok do
      it "should extract the number of OK checks" do
        subject.ok.should == 20
      end
    end
    
    describe :warning do
      pending "should extract the number of warning checks" do
      end
    end
    
    describe :warning_unhandled do
      pending "it should extract the number of unhandled warnings" do
      end
    end
    
    describe :warning_acknowledged do
      pending "it should extract the number of acknowledged warnings" do
      end
    end
    
    describe :warning_disabled do
      pending "it should extract the number of disabled warnings" do
      end
    end
    
    describe :unknown do
      it "should extract the number of unknown checks" do
        subject.critical.should == 1
      end
    end
    
    describe :unknown_unhandled do
      pending "it should extract the number of unhandled unknowns" do
      end
    end
    
    describe :unknown_acknowledged do
      pending "it should extract the number of acknowledged unknowns" do
      end
    end
    
    describe :unknown_disabled do
      pending "it should extract the number of disabled unknowns" do
      end
    end
    
    describe :critical do
      it "should extract the number of critical checks" do
        subject.critical.should == 1
      end
    end
    
    describe :critical_unhandled do
      pending "it should extract the number of unhandled criticals" do
      end
    end
    
    describe :critical_acknowledged do
      pending "it should extract the number of acknowledged criticals" do
      end
    end
    
    describe :critical_disabled do
      pending "it should extract the number of disabled criticals" do
      end
    end
    
    describe :unhandled do
      it "should extract the number of unhandled checks" do
        subject.unhandled.should == 1
      end
    end
  end
end