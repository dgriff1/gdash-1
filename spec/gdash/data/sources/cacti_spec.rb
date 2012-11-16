require "spec_helper"

module GDash
  module Data
    module Sources
      describe Cacti do
        let :cacti do
          Cacti.new
        end

        subject { cacti }

        it { should be_a Source }
      end
    end
  end
end