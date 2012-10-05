require "spec_helper"

module GDash
  describe "Doc", :type => :request do

    before do
      @context_class = Class.new
      @context = @context_class.new
      @template = Tilt.new(File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. .. lib gdash views doc.haml})))
    end

    subject do
      @template.render @context
    end
  end
end