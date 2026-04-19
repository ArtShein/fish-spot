module ApplicationHelper
  # Same host as current request only (avoids open redirects via Referer).
  def page_back_href(fallback: nil)
    fallback ||= root_path
    ref = request.referer
    return fallback if ref.blank?

    uri = URI.parse(ref)
    return fallback if uri.host.present? && uri.host != request.host

    ref
  rescue URI::InvalidURIError
    fallback
  end
end
