module Internationalization
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale

    private

    def switch_locale(&action)
      locale = locale_from_url || locale_from_headers || I18n.default_locale
      response.set_header "Content-Language", locale
      I18n.with_locale(locale, &action)
    end

    def locale_from_url
      locale = params[:locale]
      locale if I18n.available_locales.map(&:to_s).include?(locale)
    end

    def locale_from_headers
      header = request.env["HTTP_ACCEPT_LANGUAGE"]
      return if header.nil?

      locales = parse_header(header)
      return if locales.empty?

      return locales.last unless I18n.enforce_available_locales

      detect_from_available(locales)
    end

    def parse_header(header)
      header.gsub(/\s+/, "").split(",").map do |language_tag|
        locale, quantity = language_tag.split(";q=/i")
        quantity = quantity ? quantity.to_f : 1.0
        [ locale, quantity ]
      end.reject do |(locale, quantity)|
        locale == "*" || quantity.zero?
      end.sort_by do |(_, quantity)|
        quantity
      end.map(&:first)
    end

    def detect_from_available(locales)
      locales.reverse.find { |l| I18n.available_locales.any? { |al| match?(al, l) } }
      I18n.available_locales.find { |al| match?(al, locale) } if locale
    end

    def match?(str1, str2)
      str1.to_s.casecmp(str2.to_s).zero?
    end

    def default_url_options
      { locale: I18n.locale }
    end
  end
end