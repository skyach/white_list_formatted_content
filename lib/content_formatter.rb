require 'RedCloth'
require 'white_list_helper'

module ContentFormatter
  include ActionView::Helpers::TagHelper,
          ActionView::Helpers::TextHelper,
          ActionView::Helpers::UrlHelper,
          WhiteListHelper

  def self.format_content(body)
    body.strip! if body.respond_to?(:strip!)
    body.blank? ? '' : self.body_html_with_formatting(body)
  end

  private

  def self.body_html_with_formatting(body)
    body_html = auto_link(body) { |text| truncate(text, :length => 50) }
    textilized = RedCloth.new(body_html, [ :hard_breaks ])
    textilized.hard_breaks = true if textilized.respond_to?("hard_breaks=")
    white_list(textilized.to_html)
  end
end
