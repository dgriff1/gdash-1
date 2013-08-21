module GDash
  class Snapshot < View
    class << self
      def generate!
        STDERR.puts "Copying static files"
        copy_static!

        STDERR.puts "Generating index"
        generate_index!

        STDERR.puts "Generating dashboards"
        Window.each do |window|
          Dashboard.each do |dashboard|
            dashboard.pages.each do |page|
              tab_tree(page).each do |tab_path|
                begin
                  generate_page! dashboard, page, tab_path, window
                rescue Exception => ex
                  STDERR.puts "#{ex.class}: #{ex.message}"
                end
              end
            end
          end
        end

        STDERR.puts "Waiting for downloads to complete"
        download_threads.shutdown
        STDERR.puts "All downloads complete!"

        STDERR.puts "Dashboards written to #{dir.inspect}"
      end

      def tab_tree page
        @tab_tree = [[]]
        build_tab_tree page, []
        @tab_tree
      end

      def build_tab_tree page, tab_path = []
        page.children.each do |child|
          if child.is_a? TabSet
            child.tabs.each do |tab|
              extended_tab_path = tab_path + [tab.name]
              @tab_tree << extended_tab_path
              build_tab_tree tab, extended_tab_path
            end
          end
        end
      end

      def layout
        @layout ||= File.open(File.absolute_path("#{__FILE__}/../views/layout.haml")).read 
      end

      def index
        @index ||= File.open(File.absolute_path("#{__FILE__}/../views/index.haml")).read 
      end

      def generate_page! dashboard, page, tab_path, window
        view = Snapshot.new(dashboard, :page => page, :window => window, :tab_path => tab_path)
        filename = dir + view.dashboard_path(dashboard, page, *(tab_path + [:window => window]))
        dirname = File.dirname(filename)
        FileUtils.mkdir_p dirname
        File.open filename, "w" do |file|
          html = haml layout, view, :dashboard => dashboard
          fix_external_refs! html
          file.write html.to_s
          STDERR.puts "Wrote #{filename}"
        end      
      end

      def generate_index!
        filename = dir + "/index.html"
        dirname = File.dirname(filename)
        FileUtils.mkdir_p dirname
        File.open filename, "w" do |file|
          html = haml index
          fix_external_refs! html
          file.write html.to_s
          STDERR.puts "Wrote #{filename}"
        end      
      end

      def tempdir
        @tempdir ||= Dir.mktmpdir
      end

      def dir
        unless @dir
          timestamp = DateTime.now.strftime("%Y%m%d%H%M%S")
          @dir = tempdir + "/snapshot-#{timestamp}"
          FileUtils.mkdir_p @dir
        end

        @dir
      end

      def copy_static!
        FileUtils.cp_r File.absolute_path("#{__FILE__}/../public/css"), dir
        FileUtils.cp_r File.absolute_path("#{__FILE__}/../public/js"), dir
        FileUtils.cp_r File.absolute_path("#{__FILE__}/../public/img"), dir      
      end

      def haml template, view = Object.new, instance_variables = {}
        haml = Haml::Engine.new(template)

        scope = Class.new do
          include Helper
        end.new
        instance_variables.each do |k, v|
          scope.instance_variable_set :"@#{k}", v
        end

        html = haml.render scope do
          view.to_html
        end

        Nokogiri::HTML(html)
      end

      def fix_external_refs! html
        fix_stylesheets! html
        fix_scripts! html
        fix_links! html
        fix_images! html
      end

      def fix_stylesheets! html
        html.css("link").each do |stylesheet|
          stylesheet["href"] = "#{dir}/#{stylesheet["href"]}"
        end
      end

      def fix_scripts! html
        html.css("script").each do |script|
          script["src"] = "#{dir}/#{script["src"]}"
        end
      end

      def fix_links! html
        html.css("a").each do |link|
          link["href"] = "#{dir}/#{link["href"]}"
        end
      end

      def download_threads
        @download_threads ||= Thread::Pool.new 50
      end        

      def download! src, dest
        download_threads.process do
          res = RestClient.get(src)
          File.open dest, "w" do |f|
            f.write res.body
          end
        end
      end

      def fix_images! html
        image_dir = "#{dir}/images"
        FileUtils.mkdir_p image_dir

        uuid = UUID.new

        html.css("img").each do |img|
          url = img["src"]

          if url =~ /^http/
            filename = "#{image_dir}/#{uuid.generate}"
            download! url, filename
            img["src"] = filename
          end
        end
      end
    end

    def dashboard_path dashboard, page = nil, *tabs
      options = tabs.extract_options!
      page = (page || current_page).name
      tabs = tabs.map { |tab| "/#{tab}" }.join
      window = (options[:window] || self.window).name
      "/dashboards/#{dashboard.name}/#{page}#{tabs}/#{window}.html"
    end

    def window_nav
      html.ul :id => "window-nav", :class => "nav nav-pills fullscreen-hidden" do
        model.windows.each do |window|
          if (self.window.nil? && window.default) or (window.name == self.window.name)
            html.li :class => "active" do
              html.a window.title, :href => dashboard_path(model, current_page, *(tab_path + [{:window => window}]))
            end
          else
            html.li do
              html.a window.title, :href => dashboard_path(model, current_page, *(tab_path + [{:window => window}]))
            end
          end
        end
      end
    end

    def widget widget, options = {}
      widget.to_s
    end
  end
end
