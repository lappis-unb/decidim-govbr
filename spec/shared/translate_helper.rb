module TranslateHelper
  def translated(attribute=nil)
    attribute = attribute.with_indifferent_access
    locale = I18n.locale

    attribute[locale]
  end
end