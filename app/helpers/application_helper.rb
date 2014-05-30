module ApplicationHelper
  def show_flashes
    flash_messages = ''

    flash.each do |flash|

      level   = flash[0]
      message = flash[1]

      flash_messages << content_tag(:div, message, id: "flash_#{level}", class: "flash")
    end

    flash_messages.html_safe
  end
end
