require "spec_helper"

class NamedExample < GDash::Named
  attr :a, :b
  attr :c, :default => 42
  attr :d do
    c * -1
  end
  attr :e, :default => {}
  attr :f, :default => []

  collection :items
end

module GDash
  describe Named do
    let! :foo_bar do
      GDash.named_example :foo_bar, :foo => :bar, :a => "A" do |foo|
        foo.description = "A Description"
        foo.b = "B"
        foo.options :baz => :quux
        foo.item :asdf
        foo.item :fdsa
      end
    end

    let! :baz_quux do
      GDash.named_example :baz_quux, :foo => :bar, :a => "A" do
        description "A Description"
        b "B"
        options :baz => :quux
        item :asdf
        item :fdsa
      end
    end

    describe ".[]" do
      context "with foo_bar" do
        subject { NamedExample[:foo_bar] }
        it { should == foo_bar }
      end

      context "with baz_quux" do
        subject { NamedExample["baz_quux"] }
        it { should == baz_quux }
      end
    end

    describe ".all" do
      let(:all) { NamedExample.all }
      subject { all }

      it { should include foo_bar }
      it { should include baz_quux }
    end

    describe ".each" do
      let(:bases) { [] }
      before do
        NamedExample.each do |base|
          bases << base
        end
      end
      subject { bases }

      it { should include foo_bar }
      it { should include baz_quux }
    end

    describe ".named_example" do
      subject { GDash.named_example :foo_bar }
      it { should == foo_bar }
    end
  end
end