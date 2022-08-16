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

  def check_for_loop
    @force_stop_index = self.template.index("{{")
    if (self.template.include? ".loop") || (self.template.include? ".end")
      s = self.template.index("{{")
      e = self.template.index("}}")
      str = self.template[s+2..e-1]
      if str.include? ".loop"
        str = str.split(".loop").first.downcase
        replacements = { "{{#{str.upcase}.loop}}" => "<% #{str}s.each do |#{str}| %>"}
        html_to_erb(replacements)
      elsif str.include? ".end"
        str = str.split(".end").first
        replacements = { "{{#{str.upcase}.end}}" => "<% end %>"}
        html_to_erb(replacements)
      else
        check_for_variables
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

  def check_for_variables
    replacements = { '{{' => '<%=', '}}' => '%>' }
    html_to_erb(replacements)
  end

  def html_to_erb replacements
    template.gsub!(Regexp.union(replacements.keys), replacements) if template.present?
  end


end
