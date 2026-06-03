module ApplicationHelper
  def amount_badge(amount)
    amount ||= 0
    badge_class = amount > 1000 ? 'bg-danger' : 'bg-success'

    content_tag(:span, "#{amount} грн", class: "badge #{badge_class} shadow-sm")
  end
end