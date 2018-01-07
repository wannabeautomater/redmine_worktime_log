module RedmineViewCustomize
  class ViewLayoutsBaseHtmlHeadHook < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})

      view_customize_html_parts = match_customize(context[:request].path_info).map {|item|
        html(item)
      }

      return "<!-- [view customize plugin] path:#{context[:request].path_info} -->\n" +
        view_customize_html_parts.join("\n").html_safe
    end

    private

    def match_customize(path)

      ViewCustomize.all.select {|item|
        item.available? && path =~ Regexp.new(item.path_pattern)
      }
    end

    def html(view_customize)
      
      html = "<!-- view customize id:#{view_customize.id} -->\n"

      if view_customize.is_javascript? then
        html << "<script type=\"text/javascript\">\n//<![CDATA[\n"
        html << view_customize.code
        html << "\n//]]>\n</script>"
      elsif view_customize.is_stylesheet? then
        html << "<style type=\"text/css\">\n"
        html << view_customize.code
        html << "\n</style>"
      end

      return html
    end
  end
end
