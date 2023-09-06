module Decidim
  module Govbr
    class ExportUserDataController < Decidim::Admin::ApplicationController
      def export_users_basic_information
        begin
          csv_content = CSV.generate do |csv|
            csv << %w(Nome CPF E-mail)
            Decidim::User.includes(:identities).find_each do |user|
              row = [
                user.name.presence || 'Vazio',
                user.identities.first.try(:uid).presence || 'Vazio',
                user.email || 'Vazio'
              ]
              csv << row
            end
          end

          send_data csv_content, filename: "user-report-#{Date.today}.csv"
        rescue StandardError => e
          render json: {
            'error' => e.message,
            'stacktrace' => e.backtrace
          }
        end
      end
    end
  end
end