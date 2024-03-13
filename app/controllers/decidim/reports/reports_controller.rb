module Decidim
  module Reports
    # This controller handle requests for firing requests to Airflow
    class ReportsController < Decidim::ApplicationController
      def create
        # TODO: colocar o enforce permission
        date_range = params[:date_range].split(" até ")
        start_date = date_range.first
        end_date = date_range.second

        missing_params = []
        missing_params << :airflow_endpoint unless params[:airflow_endpoint].present?
        missing_params << :start_date unless start_date.present?
        missing_params << :end_date unless end_date.present?
        missing_params << :email unless params[:email].present?
        missing_params << :email unless params[:component_id].present?
        missing_params << :current_user unless current_user.present?

        return render json: { "status" => "Erro!", "message" => "Informações ausentes: #{missing_params}" } if missing_params.present?

        Govbr::Airflow::TriggerAirflowReport.call(params[:airflow_endpoint], start_date, end_date, params[:email], params[:component_id], current_user) do
          on(:ok) do
            flash[:notice] = "Sucesso! O Relatório será processado em breve e você será notificado por e-mail."
            render json: { "status" => "Sucesso!", "message" => "Você receberá um e-mail em breve." }
          end

          on(:invalid) do
            flash[:alert] = "Parametros inválidos!"
            render json: { "status" => "Erro!", "message" => "Informações ausentes: #{missing_params}" }
          end

          on(:error) do |airflow_response|
            render airflow_response
          end
        end
      end
    end
  end
end