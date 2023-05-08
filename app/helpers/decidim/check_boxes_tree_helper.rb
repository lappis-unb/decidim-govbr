# frozen_string_literal: true

module Decidim
  # This helper include some methods for rendering a checkboxes tree input.
  module CheckBoxesTreeHelper
    # This method returns a hash with the options for the checkbox and its label
    # used in filters that uses checkboxes trees
    def check_boxes_tree_options(value, label, **options)
      checkbox_options = {
        value: value,
        label: label,
        multiple: true,
        include_hidden: false,
        label_options: {
          "data-children-checkbox": "",
          value: value
        }
      }
      options.merge!(checkbox_options)

      if options.delete(:is_root_check_box) == true
        options[:label_options].merge!("data-global-checkbox": "")
        options[:label_options].delete(:"data-children-checkbox")
      end

      options
    end

    # struct for nodes of checkboxes trees
    TreeNode = Struct.new(:leaf, :node) do
      def tree_node?
        is_a?(TreeNode)
      end
    end

    # struct for leafs of checkboxes trees
    TreePoint = Struct.new(:value, :label) do
      def tree_node?
        is_a?(TreeNode)
      end
    end

    def filter_categories_values
      organization = current_participatory_space.organization

      sorted_categories = current_participatory_space.categories.order(parent_id: :asc, weight: :asc, id: :asc) do |category|
        [category.weight, translated_attribute(category.name, organization)]
      end

      sorted_main_categories = sorted_categories.select { |category| category.parent_id.nil? }

      categories_values = sorted_main_categories.flat_map do |category|
        category_descendants = sorted_categories.select { |cat| category.id == cat.parent_id }

        if category_descendants.any?
          sorted_descendant_categories = category_descendants.flat_map do |subcategory|
            [subcategory.weight, translated_attribute(subcategory.name, organization)]
          end

          subcategories = category_descendants.flat_map do |subcategory|
            TreePoint.new(subcategory.id.to_s, translated_attribute(subcategory.name, organization))
          end
        end

        TreeNode.new(
          TreePoint.new(category.id.to_s, translated_attribute(category.name, organization)),
          subcategories
        )
      end

      TreeNode.new(
        TreePoint.new("", t("decidim.proposals.application_helper.filter_category_values.all")),
        categories_values
      )
    end
  end
end