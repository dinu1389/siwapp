class Template < ActiveRecord::Base
  acts_as_paranoid

  validates :name, presence: true
  validates :template, presence: true

  def to_s
    name
  end

  def html_string
    check_for_loop
    #check_for_variables
    return template
  end

  def check_for_loop_1
    @force_stop_index = self.template.index("{{")
    if (self.template.include? ".loop") || (self.template.include? ".end") || @force_stop_index.present?
      s = self.template.index("{{")
      e = self.template.index("}}")
      str = self.template[s+2..e-1]
      if str.include? ".loop"
        str = str.split(".loop").first.downcase
        replacements = { "{{#{str}.loop}}" => "<% #{str}s&.each do |#{str}| %>"}
        html_to_erb(replacements)
      elsif str.include? ".end"
        str = str.split(".end").first
        replacements = { "{{#{str}.end}}" => "<% end %>"}
        html_to_erb(replacements)
      else
        check_for_variables(s, e)
      end
      #if braces are unable to replace below will be true and this recursive function should be stopped if not it will go into infinite loop
      if @force_stop_index == self.template.index("{{")
         return
      else
        check_for_loop
      end
    else
      return
      # self.template.split("{{{").last.split("}}}").first
    end
  end

  def check_for_variables_1 first, last
    #TODO add a check box in the frontend to use defined? so that bypass can be controlled
    # template[first..first+1] = '<%='
    # template[last+11..last+12] = '%>'
    var_str = template[first+2..last-1]
    template[first..last+1] = "<%= #{var_str} if defined?(#{var_str}) %>"
    # template[first..first+1] = "<%=defined? (#{template[first+3..last]}) && #{template[first+3..last]}"
    # #template[first+3..last] = "defined? (#{template[first+3..last]}) && #{template[first+3..last]}"
    # template[last+1..last+2] = '%>'
  end


  def check_for_loop
    replacements = { '%=' => '<%=', '#%' => '%>', '%#' => '<%' }
    return  html_to_erb(replacements)
  end

  def html_to_erb replacements
    template.gsub!(Regexp.union(replacements.keys), replacements) if template.present?
  end


end
