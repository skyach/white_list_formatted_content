require 'content_formatter'

module WhiteListFormattedContent #:nodoc:
  def self.format_attribute(attr_name)
    class << self; ; end
    define_method(:body)       { read_attribute attr_name }
    define_method(:body_html)  { read_attribute "#{attr_name}_html" }
    define_method(:body_html=) { |value| write_attribute "#{attr_name}_html", value }
    before_save :format_content
  end

  def dom_id
    [self.class.name.downcase.pluralize.dasherize, id] * '-'
  end

  protected

  def format_content
    self.body_html = ContentFormatter.format_content(body)
  end
end
