require 'content_formatter'

module WhiteListFormattedContent #:nodoc:
  def self.included(mod)
    mod.extend(ClassMethods)
  end

  module ClassMethods
    def format_attribute(attr_name)
      define_method(:body)       { read_attribute attr_name }
      define_method(:body_html)  { read_attribute "#{attr_name}_html" }
      define_method(:body_html=) { |value| write_attribute "#{attr_name}_html", value }
      before_save :format_content

      include WhiteListFormattedContent::InstanceMethods
    end
  end

  module InstanceMethods
    def dom_id
      [self.class.name.downcase.pluralize.dasherize, id] * '-'
    end

    protected

    def format_content
      self.body_html = ContentFormatter.new(body).format_content
    end
  end
end

ActiveRecord::Base.class_eval do
  include WhiteListFormattedContent
end
