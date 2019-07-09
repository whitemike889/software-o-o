# frozen_string_literal: true

# Helper for distribution controller
module DistributionHelper
  def leap_image_tag(opts = {})
    image_name = @version == @testing_version ? 'testing' : 'leap'
    image_tag("distributions/#{image_name}-white.svg", opts)
  end

  def markdownify(text)
    options = { filter_html: true }

    extensions = { autolink: true }

    render = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(render, extensions)

    markdown.render(text).html_safe
  end

  def retrieve_image_size(url)
    conn = Faraday.new(url: url) do |f|
      f.use FaradayMiddleware::FollowRedirects
      f.request  :url_encoded
      f.adapter  Faraday.default_adapter
    end
    # Turn into integer just in case we have dead links (they will report 0B)
    conn.head.headers['content-length'].to_i
  end

  def short_description(short_desc, image_size)
    return short_desc if short_desc.present?

    case image_size
    when 0..700_000_000
      _("For CD and USB stick")
    when 700_000_001..5_000_000_000
      _("For DVD and USB stick")
    else
      _("For USB stick")
    end
  end
end
