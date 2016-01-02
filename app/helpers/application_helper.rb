module ApplicationHelper
	def page_title
		content_for(:title)
	end

	def page_heading(title)
		content_for(:title){ title }
	end
end
