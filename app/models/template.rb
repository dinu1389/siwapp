class Template < ActiveRecord::Base
  acts_as_paranoid

  validates :name, presence: true
  validates :template, presence: true

  def to_s
    name
  end

  def html_string
    replacements = { '{{' => '<%=', '}}' => '%>' }
    return  template.gsub(Regexp.union(replacements.keys), replacements) if template.present?
  end

end
