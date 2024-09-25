# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    class ChangeActiveStepJob < ApplicationJob
      queue_as :default

      def perform(_start_date)
        time_now = Time.current

        participatory_processes = current_participatory_processes(time_now)

        participatory_processes.each do |process|
          steps = process.steps.order(:position)
          desired_step = find_desired_step(steps, time_now)
          active_steps = steps.select(&:active)

          update_steps(active_steps, desired_step)
        end
      end

      def self.clear(start_date:)
        scheduled_jobs = Sidekiq::ScheduledSet.new

        scheduled_jobs.each do |job|
          next unless job.klass == "ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper" &&
                      job.item["wrapped"] == "Decidim::ParticipatoryProcesses::ChangeActiveStepJob" &&
                      job.item["args"].first["arguments"].include?(start_date)

          job.delete
        end
      end

      private

      def current_participatory_processes(time_now)
        Decidim::ParticipatoryProcess.published.where(
          "start_date <= ? AND end_date >= ?", time_now.to_date, time_now.to_date
        )
      end

      def find_desired_step(steps, time_now)
        steps_within_time = steps.select do |step|
          step.start_date.present? &&
            step.start_date <= time_now &&
            (step.end_date.nil? || step.end_date >= time_now)
        end

        # Seleciona o passo com o start_date mais recente
        steps_within_time.max_by(&:start_date)
      end

      def update_steps(active_steps, desired_step)
        active_steps.each do |active_step|
          active_step.update(active: false) unless active_step == desired_step
        end

        desired_step&.update(active: true) unless desired_step&.active?
      end
    end
  end
end
