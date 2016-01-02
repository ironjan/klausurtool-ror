module ApplicationHelper
	def page_title(separator = " – ")
		title = [content_for(:title), 'Klausurtool RoR'].compact.join(separator)
		Rails.logger.debug("page_title => #{title}")
		title
	end

	def page_heading(title)
		Rails.logger.debug("Applying content_for with #{title}")
		content_for(:title){ title }
		content_tag(:h1, title)
	end
end
