# frozen_string_literal: true

module Decidim
  module Govbr
    module Airflow
      # A command to fire report requests on airflow, by specifying the endpoint, the start_date
      # the end_date and the component_id to build report on
      class TriggerAirflowReport < Decidim::Command
        def initialize(endpoint, start_date, end_date, email, component_id, current_user)
          @endpoint = endpoint
          @start_date = start_date
          @end_date = end_date
          @email = email
          @component_id = component_id
          @current_user = current_user
        end

        attr_reader :endpoint, :start_date, :end_date, :email, :component_id, :current_user

        def call
          # TODO: move this to a specific Form
          return broadcast(:invalid) if invalid_params?

          begin
            fire_request!
          rescue RestClient::ExceptionWithResponse => e
            return broadcast(:error, e.response)
          end

          broadcast(:ok)
        end

        def invalid_params?
          return true unless endpoint && start_date && end_date && component_id && current_user
        end

        def username
          ENV["USER_AIRFLOW"]
        end

        def password
          ENV["PASSWORD_AIRFLOW"]
        end

        def airflow_host
          ENV["HOST_AIRFLOW"]
        end

        def fire_request!
          uri = "http://#{airflow_host}/api/v1/dags/#{endpoint}/dagRuns"
          headers = {
            "Authorization" => "Basic #{Base64.encode64("#{username}:#{password}")}",
            "Content-Type" => "application/json"
          }
          body = {
            "conf" => {
              "start_date" => start_date,
              "end_date" => end_date,
              "email" => email,
              "component_id" => component_id
            }
          }

          RestClient.post(uri, body.to_json, headers)
        end
      end
    end
  end
end