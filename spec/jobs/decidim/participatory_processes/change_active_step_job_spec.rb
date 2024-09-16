# frozen_string_literal: true

require "rails_helper"

describe Decidim::ParticipatoryProcesses::ChangeActiveStepJob do
  subject { described_class }

  describe "queue" do
    it "is queued to default queue" do
      expect(subject.queue_name).to eq "default"
    end
  end

  describe "perform" do
    let(:organization) { create(:organization) }
    let!(:participatory_process) do
      create(
        :participatory_process,
        organization: organization,
        description: { en: "Description", ca: "Descripció", es: "Descripción" },
        short_description: { en: "Short description", ca: "Descripció curta", es: "Descripción corta" },
        published_at: Time.zone.local(2022, 3, 1, 10, 0, 0),
        start_date: Time.zone.local(2022, 3, 1, 10, 0, 0),
        end_date: Time.zone.local(2022, 3, 31, 10, 0, 0)
      )
    end

    before do
      allow(Time.zone).to receive(:now).and_return(Time.zone.local(2022, 3, 15, 11, 0, 0))
    end

    context "with one step" do
      context "when not activated but enters period" do
        let!(:step) do
          create(
            :participatory_process_step,
            participatory_process: participatory_process,
            start_date: Time.zone.local(2022, 3, 14, 10, 0, 0),
            end_date: Time.zone.local(2022, 3, 16, 10, 0, 0)
          )
        end

        before { subject.perform_now(step.start_date.to_s) }

        it "activates the step" do
          expect(step.reload).to be_active
        end
      end

      context "when activated but period has not started" do
        let!(:step) do
          create(
            :participatory_process_step,
            participatory_process: participatory_process,
            active: true,
            start_date: Time.zone.local(2022, 3, 16, 10, 0, 0),
            end_date: Time.zone.local(2022, 3, 20, 10, 0, 0)
          )
        end

        before { subject.perform_now(step.start_date.to_s) }

        it "deactivates the step" do
          expect(step.reload).not_to be_active
        end
      end
    end

    context "with steps without dates" do
      context "when step has no start_date" do
        let!(:step) do
          create(
            :participatory_process_step,
            participatory_process: participatory_process,
            start_date: nil,
            end_date: Time.zone.local(2022, 3, 16, 10, 0, 0)
          )
        end

        before { subject.perform_now(Time.zone.now.to_s) }

        it "does not activate the step" do
          expect(step.reload).not_to be_active
        end
      end

      context "when step has no end_date" do
        let!(:step) do
          create(
            :participatory_process_step,
            participatory_process: participatory_process,
            start_date: Time.zone.local(2022, 3, 14, 10, 0, 0),
            end_date: nil
          )
        end

        before { subject.perform_now(step.start_date.to_s) }

        it "activates the step" do
          expect(step.reload).to be_active
        end
      end
    end

    context "with overlapping steps" do
      let!(:step_one) do
        create(
          :participatory_process_step,
          participatory_process: participatory_process,
          active: true,
          start_date: Time.zone.local(2022, 3, 13, 10, 0, 0),
          end_date: Time.zone.local(2022, 3, 16, 10, 0, 0)
        )
      end
      let!(:step_two) do
        create(
          :participatory_process_step,
          participatory_process: participatory_process,
          start_date: Time.zone.local(2022, 3, 15, 10, 0, 0),
          end_date: Time.zone.local(2022, 3, 18, 10, 0, 0)
        )
      end
      let!(:step_three) do
        create(
          :participatory_process_step,
          participatory_process: participatory_process,
          start_date: Time.zone.local(2022, 3, 17, 10, 0, 0),
          end_date: Time.zone.local(2022, 3, 20, 10, 0, 0)
        )
      end

      before { subject.perform_now(step_two.start_date.to_s) }

      it "activates the correct step based on current time" do
        expect(step_one.reload).not_to be_active
        expect(step_two.reload).to be_active
        expect(step_three.reload).not_to be_active
      end
    end

    context "when the process is not published" do
      let!(:step) do
        create(
          :participatory_process_step,
          participatory_process: participatory_process,
          start_date: Time.zone.local(2022, 3, 14, 10, 0, 0),
          end_date: Time.zone.local(2022, 3, 16, 10, 0, 0)
        )
      end

      before do
        participatory_process.update!(published_at: nil)
        subject.perform_now(step.start_date.to_s)
      end

      it "does not activate the step" do
        expect(step.reload).not_to be_active
      end
    end

    context "when the process is out of date range" do
      let!(:step) do
        create(
          :participatory_process_step,
          participatory_process: participatory_process,
          start_date: Time.zone.local(2022, 3, 14, 10, 0, 0),
          end_date: Time.zone.local(2022, 3, 16, 10, 0, 0)
        )
      end

      before do
        participatory_process.update!(start_date: Time.zone.local(2022, 4, 1, 10, 0, 0))
        subject.perform_now(step.start_date.to_s)
      end

      it "does not activate the step" do
        expect(step.reload).not_to be_active
      end
    end

    context "when scheduling the job for the future" do
      let!(:step) do
        create(
          :participatory_process_step,
          participatory_process: participatory_process,
          start_date: Time.zone.now + 5.days,
          end_date: Time.zone.now + 10.days
        )
      end

      it "schedules the job correctly" do
        expect do
          Decidim::ParticipatoryProcesses::ChangeActiveStepJob.set(wait_until: step.start_date).perform_later(step.start_date.to_s)
        end.to have_enqueued_job.at(step.start_date)
      end
    end

    context "when clearing previous scheduled jobs" do
      let!(:step) do
        create(
          :participatory_process_step,
          participatory_process: participatory_process,
          start_date: Time.zone.now + 5.days,
          end_date: Time.zone.now + 10.days
        )
      end

      it "clears the job scheduled with previous start_date" do
        # Enfileira o job com a data anterior
        Decidim::ParticipatoryProcesses::ChangeActiveStepJob.set(wait_until: step.start_date).perform_later(step.start_date.to_s)
        # Altera o start_date
        previous_start_date = step.start_date
        new_start_date = step.start_date + 2.days
        step.update!(start_date: new_start_date)
        # Chama o método para limpar o job antigo
        Decidim::ParticipatoryProcesses::ChangeActiveStepJob.clear(start_date: previous_start_date.to_s)
        # Verifica se o job antigo foi removido
        scheduled_jobs = Sidekiq::ScheduledSet.new
        jobs_with_old_date = scheduled_jobs.select do |job|
          job.args.first["arguments"].include?(previous_start_date.to_s)
        end
        expect(jobs_with_old_date).to be_empty
      end
    end
  end
end
