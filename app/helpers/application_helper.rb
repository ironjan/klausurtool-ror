module ApplicationHelper
  include ImtToNameHelper

  def page_title
    content_for(:title)
  end

  def page_heading(title)
    content_for(:title) { title }
  end

  def is_midori?
    user_agent = request.env['HTTP_USER_AGENT']

    if user_agent.nil?
      user_agent = ''
    end

    user_agent.downcase.include? "midori"
  end
end
