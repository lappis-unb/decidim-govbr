# frozen_string_literal: true

require "decidim/form_builder"

module Decidim
  # This custom FormBuilder is used to create resource filter forms
  class FilterFormBuilder < FormBuilder
    # Wrap the dependant check_boxes in a custom fieldset.
    # checked parent checks its children
    def check_boxes_tree(method, collection, options = {})
      Rails.cache.fetch(cache_hash(collection)) do
        fieldset_wrapper(options.delete(:legend_title), "#{method}_check_boxes_tree_filter") do
          @template.render("decidim/shared/check_boxes_tree",
                           form: self,
                           attribute: method,
                           collection: collection,
                           check_boxes_tree_id: check_boxes_tree_id(method),
                           hide_node: "false",
                           options: options).html_safe
        end
      end
    end

    private

    def cache_hash(collection)
      hash = []
      hash << "decidim/shared/check_boxes_tree"
      hash << Digest::MD5.hexdigest(collection.to_s)
      hash << I18n.locale.to_s
      hash.join(Decidim.cache_key_separator)
    end

    # Private: Renders a custom fieldset and execute the given block.
    def fieldset_wrapper(legend_title, extra_class)
      @template.content_tag(:div, "", class: "filters__section #{extra_class}") do
        @template.content_tag(:fieldset) do
          @template.content_tag(:legend, class: "mini-title") do
            legend_title
          end + yield
        end
      end
    end

    def check_boxes_tree_id(attribute)
      "#{attribute}-#{object_id}"
    end
  end
end