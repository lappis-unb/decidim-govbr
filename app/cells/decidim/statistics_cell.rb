# frozen_string_literal: true

module Decidim
  # This cell renders the Statistics of a Resource
  class StatisticsCell < Decidim::ViewModel
    private

    def stats
      @stats ||= model
    end

    def stats_heading
      t("decidim.statistics.headline")
    end

    def no_stats
      t("decidim.statistics.no_stats")
    end

    def mock_stats
      [
        {
          stat_number: 123,
          stat_title: "Recomendações"
        },
        {
          stat_number: 456,
          stat_title: "Comentários"
        },
        {
          stat_number: 789,
          stat_title: "Seguidores"
        },
        {
          stat_number: 101112,
          stat_title: "Respostas"
        },
        {
          stat_number: 131415,
          stat_title: "Participantes"
        }
      ]
    end
    def heading?
      if options[:heading].nil?
        true
      else
        options[:heading]
      end
    end

    def design
      options[:design].presence || "default"
    end

    def wrapper_class
      "large-8" if design == "default"
    end
  end
end
