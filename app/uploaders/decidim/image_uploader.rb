# frozen_string_literal: true

module Decidim
  # This class deals with uploading hero images to ParticipatoryProcesses.
  class ImageUploader < ApplicationUploader
    def validable_dimensions
      true
    end

    def content_type_allowlist
      extension_allowlist.map { |ext| "image/#{ext}" }
    end

    # Fetches info about different variants, their processors and dimensions
    def dimensions_info
      return if variants.blank?

      variants.transform_values do |variant|
        {
          processor: variant.keys.first,
          dimensions: variant.values.first
        }
      end
    end

    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
    def extension_allowlist
      Decidim.organization_settings(model).upload_allowed_file_extensions_image
    end

    def max_image_height_or_width
      1000
    end

    def max_image_height(attribute)
      if attribute == :hero_image
        155
      else
        410
      end
    end

    def max_image_widht(attribute)
      if attribute == :hero_image
        1140
      else
        703
      end
    end

    private

    def maximum_upload_size
      3000
    end
  end
end
