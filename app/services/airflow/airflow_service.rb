require 'rest-client'

module Services
  module Airflow
    class AirflowService
      def self.enqueue_report(airflow_host:,endpoint:,start_date:,end_date:,email:,component_id:)
        url = "http://#{airflow_host}/api/v1/dags/#{endpoint}/dagRuns"
        username = ENV[:USER_AIRFLOW]
        password = ENV[:PASSWORD_AIRFLOW]
        basic_auth = "Basic #{Base64.encode64("#{username}:#{password}")}"
        headers = {
          :Authorization => basic_auth,
          :"Content-Type" => "application/json"
        }
        body = {
          :conf => {
            :start_date => start_date,
            :end_date => end_date,
            :email => email,
            :component_id => component_id,
          }
        }

        response = RestClient.post(url,headers,body)

        parsed_response = JSON.parse(response).with_indifferent_access

        if (parsed_response["status"].present? && parsed_response["status"] >= 400) || JSON.parse(response).blank?
          "Algum erro ocorreu ao enviar relatório para a fila!"
        elsif parsed_response["status"].present? && parsed_response["status"] == 200
          "O relatório foi enviado para a fila com sucesso!"
        end
      end
    end
  end
end