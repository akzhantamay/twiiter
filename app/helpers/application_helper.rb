module ApplicationHelper
    def full_title(title)
        base_title = "Twitter"
        if title.present? 
            "#{base_title} | #{title}"
        else
            base_title
        end
    end
end
