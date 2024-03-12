module Decidim
  module Reports
    class ReportsController < ApplicationController

      def generate_report
        airflow_host = "200.152.47.48:8080"
        endpoint = params[:airflow_endpoint]
        date_range = params[:date_range].split(" até ")
        start_date = date_range.first
        end_date = date_range.second
        email = params[:email]
        component_id = params[:id]

        Services::Airflow::AirflowService.enqueue_report(
          airflow_host:airflow_host,
          endpoint:endpoint,
          start_date:start_date,
          end_date:end_date,
          email:email,
          component_id:component_id
        )

        return
      end
    end
  end
end