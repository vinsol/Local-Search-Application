module KernelViewExt
  
  # Collects each argument and outputs the results
  #   collect stylesheet_link_tag('map_frame', :media => :all),
  #           javascript_include_tag('jquery'),
  #           some_other_stuff
  def collect(*args)
    args.compact.join("\n")
  end
  
  def javascript(&block)
    update_page do |script|
      Eschaton.with_global_script script, &block
    end
  end

  def run_javascript(&block)
    update_page_tag do |script|
      Eschaton.with_global_script script, &block
    end
  end

end