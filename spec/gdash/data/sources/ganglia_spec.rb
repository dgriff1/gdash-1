require "spec_helper"

module GDash
  module Data
    module Sources
      describe Ganglia do
        let :ganglia do
          Ganglia.new
        end

        subject { ganglia }

        it { should be_a Source }
      end
    end
  end
end