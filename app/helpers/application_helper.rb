module ApplicationHelper

  # returns an array to be passed to a Rails fragment `cache` method call.
  # designed to work with a cohort and one of it's associations, such as
  # assignments, events, etc.
  #
  # the final values, `opt` can be anything, but are usually used for an option
  # related to the current user, such as whether or not they are an admin,
  # or possible the user object itself.
  def cache_key_for_cohort(cohort, association, *opt)
    return ["cohort-#{cohort.id}/events", association.maximum(:updated_at), *opt]
  end

  def avatar user, cssClass = "avatar"
    if user.image_url && !user.image_url.strip.blank?
      return link_to image_tag(user.image_url), user_path(user), class: cssClass
    end
  end

  def color_of_percent input, type = :good
    # can't do calculations on nil values
    return "" if input.nil?

    # if the input is a 'bad' value, flip and scale the value accordingly.
    # e.g. a good value would be %HW complete, and 75% would be green
    #
    # but a bad value might be "% absent", and 10% would be yellow
    input = (100 - (input* 3)) if type == :bad

    case input
    when -1000...25
      return "status_very_bad"
    when 25...50
      return "status_bad"
    when 50...75
      return "status_mediocre"
    when 75..1000
      return "status_good"
    end
  end

  def color_of_status input
    case input
    when "red"
      return "status_very_bad"
    when "yellow"
      return "status_mediocre"
    when "green"
      return "status_good"
    end
  end

  def percent_of collection, value
    divisor = collection.select{|i| i.status == value}
    divisor = divisor.length
    if divisor <= 0
      percent = 0
    else
      percent = (divisor.to_f / collection.length).round(2)
    end
    return (percent * 100).to_i
  end

  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true,
      fenced_code_blocks: true
    }
    if text.blank?
      nil
    else
      renderer = Redcarpet::Render::HTML.new(options)
      markdown = Redcarpet::Markdown.new(renderer, extensions)
      "<div class='markdown'>#{markdown.render(text)}</div>".html_safe
    end
  end

  def cohort_status(cohort, user)
    user.memberships.find_by(cohort: cohort).status.to_s
  end

end
