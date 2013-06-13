require "spec_helper"

class Obj < GDash::Base
  attr :x
  attr :z
end

class Example < GDash::Base
  attr :a, :b
  attr :c, :default => 42
  attr :d do
    c * -1
  end
  attr :e, :default => {}
  attr :f, :default => []

  collection :items
  collection :objs, :class => Obj
  collection :bars, :prototype => false
end

module GDash
  describe Base do
    let! :foo_bar do
      GDash.example :foo_bar, :foo => :bar, :a => "A" do |foo|
        foo.description = "A Description"
        foo.b = "B"
        foo.options :baz => :quux
        foo.item :asdf
        foo.item :fdsa
        foo.obj :qwerty, :x => :y do |obj|
          obj.z :w
        end
        foo.bar :wasd
      end
    end

    let! :baz_quux do
      GDash.example :baz_quux, :foo => :bar, :a => "A" do
        description "A Description"
        b "B"
        options :baz => :quux
        item :asdf
        item :fdsa
        obj :qwerty, :x => :y do
          z :w
        end
        bar :wasd
      end
    end

    let! :asdf do
      GDash.example :asdf, :prototype => baz_quux, :a => "Z" do
        b "Y"
        item :qwerty
        options :r => :s
        bar :dsaw
      end
    end

    describe ".define" do
      context "with explicit yield" do
        subject { foo_bar }

        it { should be_an Example }
        its(:name) { should == "foo_bar" }
        its(:title) { should == "Foo Bar" }
        its(:description) { should == "A Description" }
        its(:a) { should == "A" }
        its(:b) { should == "B" }
        its(:c) { should == 42 }
        its(:d) { should == -42 }
        its(:e) { should == {} }
        its(:f) { should == [] }
        its(:items) { should == [:asdf, :fdsa] }
        its(:options) { should == { "foo" => :bar, "baz" => :quux } }
        its(:bars) { should == [:wasd] }

        describe "#objs" do
          subject { foo_bar.objs.first }

          it { should be_an Obj }
          its(:name) { should == "qwerty" }
          its(:x) { should == :y }
          its(:z) { should == :w }
        end
      end

      context "with instance eval" do
        subject { baz_quux }

        it { should be_an Example }
        its(:name) { should == "baz_quux" }
        its(:title) { should == "Baz Quux" }
        its(:description) { should == "A Description" }
        its(:a) { should == "A" }
        its(:b) { should == "B" }
        its(:c) { should == 42 }
        its(:d) { should == -42 }
        its(:e) { should == {} }
        its(:f) { should == [] }
        its(:items) { should == [:asdf, :fdsa] }
        its(:options) { should == { "foo" => :bar, "baz" => :quux } }
        its(:bars) { should == [:wasd] }

        describe "#objs" do
          subject { baz_quux.objs.first }

          it { should be_an Obj }
          its(:name) { should == "qwerty" }
          its(:x) { should == :y }
          its(:z) { should == :w }
        end
      end
    end

    describe "#prototype" do
      subject { asdf }

      it { should be_an Example }
      its(:name) { should == "asdf" }
      its(:title) { should == "Asdf" }
      its(:prototype) { should == baz_quux }
      its(:description) { should == "A Description" }
      its(:a) { should == "Z" }
      its(:b) { should == "Y" }
      its(:c) { should == 42 }
      its(:d) { should == -42 }
      its(:e) { should == {} }
      its(:f) { should == [] }
      its(:items) { should == [:asdf, :fdsa, :qwerty] }
      its(:options) { should == { "foo" => :bar, "baz" => :quux, "r" => :s } }
      its(:bars) { should == [:dsaw] }

      describe "#objs" do
        subject { baz_quux.objs.first }

        it { should be_an Obj }
        its(:name) { should == "qwerty" }
        its(:x) { should == :y }
        its(:z) { should == :w }
      end
    end

    describe ".attr" do
      let! :a do
        Example.new :foo do
          e[:foo] = "foo"
          f << :foo
        end
      end

      let! :b do
        Example.new :bar do
          e[:bar] = "bar"
          f << :bar
        end
      end

      context "a" do
        subject { a }

        its(:e) { should have_key :foo }
        its(:e) { should_not have_key :bar }
        its(:f) { should include :foo }
        its(:f) { should_not include :bar }
      end

      context "b" do
        subject { b }

        its(:e) { should_not have_key :foo }
        its(:e) { should have_key :bar }
        its(:f) { should_not include :foo }
        its(:f) { should include :bar }
      end
    end

    describe ".example" do
      subject { GDash.example :foo_bar }
      it { should be_an Example }
      its(:name) { should == "foo_bar" }
    end

    describe ".attrs" do
      subject { Example.attrs }

      it { should include :name }
      it { should include :title }
      it { should include :description }
      it { should include :a }
      it { should include :b }
      it { should include :c }
      it { should include :d }
      it { should include :e }
      it { should include :f }
      it { should include :items }
      it { should include :options }
      it { should include :bars }
    end

    describe "#initialize" do
      let! :foo_bar do
        Example.new :foo_bar, :foo => :bar, :a => "A" do |foo|
          foo.description = "A Description"
          foo.b = "B"
          foo.options :baz => :quux
          foo.item :asdf
          foo.item :fdsa
          foo.obj :qwerty, :x => :y do |obj|
            obj.z :w
          end
          foo.bar :wasd
        end
      end

      let! :baz_quux do
        Example.new :baz_quux, :foo => :bar, :a => "A" do
          description "A Description"
          b "B"
          options :baz => :quux
          item :asdf
          item :fdsa
          obj :qwerty, :x => :y do
            z :w
          end
          bar :wasd
        end
      end

      context "with explicit yield" do
        subject { foo_bar }

        it { should be_an Example }
        its(:name) { should == "foo_bar" }
        its(:title) { should == "Foo Bar" }
        its(:description) { should == "A Description" }
        its(:a) { should == "A" }
        its(:b) { should == "B" }
        its(:c) { should == 42 }
        its(:d) { should == -42 }
        its(:e) { should == {} }
        its(:f) { should == [] }
        its(:items) { should == [:asdf, :fdsa] }
        its(:options) { should == { "foo" => :bar, "baz" => :quux } }
        its(:bars) { should == [:wasd] }

        describe "#objs" do
          subject { foo_bar.objs.first }

          it { should be_an Obj }
          its(:name) { should == "qwerty" }
          its(:x) { should == :y }
          its(:z) { should == :w }
        end
      end

      context "with instance eval" do
        subject { baz_quux }

        it { should be_an Example }
        its(:name) { should == "baz_quux" }
        its(:title) { should == "Baz Quux" }
        its(:description) { should == "A Description" }
        its(:a) { should == "A" }
        its(:b) { should == "B" }
        its(:c) { should == 42 }
        its(:d) { should == -42 }
        its(:e) { should == {} }
        its(:f) { should == [] }
        its(:items) { should == [:asdf, :fdsa] }
        its(:options) { should == { "foo" => :bar, "baz" => :quux } }
        its(:bars) { should == [:wasd] }

        describe "#objs" do
          subject { baz_quux.objs.first }

          it { should be_an Obj }
          its(:name) { should == "qwerty" }
          its(:x) { should == :y }
          its(:z) { should == :w }
        end
      end
    end
  end
end