require 'rails_autolink'
require 'RedCloth'
require 'white_list_helper'

class ContentFormatter
  include ActionView::Helpers
  include WhiteListHelper

  def initialize(body)
    @body = body
  end

  def format_content
    @body.strip! if @body.respond_to?(:strip!)
    @body.blank? ? '' : body_html_with_formatting
  end

  private

  def body_html_with_formatting
    body_html = auto_link(@body) { |text| truncate(text, :length => 50) }
    textilized = RedCloth.new(body_html, [ :hard_breaks ])
    textilized.hard_breaks = true if textilized.respond_to?("hard_breaks=")
    white_list(textilized.to_html)
  end
end
