# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Forms
    module Admin
      describe QuestionnaireForm do
        subject do
          described_class.from_params(attributes).with_context(
            current_organization: current_organization
          )
        end

        let(:current_organization) { create(:organization) }

        let(:title) do
          {
            "en" => "Title",
            "ca" => "Title",
            "es" => "Title"
          }
        end

        let(:tos) do
          {
            "en" => tos_english,
            "ca" => "<p>TOS: contingut</p>",
            "es" => "<p>TOS: contenido</p>"
          }
        end

        let(:description) do
          {
            "en" => "<p>Content</p>",
            "ca" => "<p>Contingut</p>",
            "es" => "<p>Contenido</p>"
          }
        end

        let(:body_english) { "First question" }
        let(:tos_english) { "<p>TOS: content</p>" }

        let(:questions) do
          [
            {
              body: {
                "en" => body_english,
                "ca" => "Primera pregunta",
                "es" => "Primera pregunta"
              },
              position: 0,
              question_type: "short_answer"
            },
            {
              body: {
                "en" => "Second question",
                "ca" => "Segona pregunta",
                "es" => "Segunda pregunta"
              },
              position: 1,
              mandatory: true,
              question_type: "short_answer",
              max_characters: 30
            }
          ]
        end

        let(:topp_english) { "Topp EN" }

        let(:collect_user_data) { "0" }

        let(:topp) do
          {
            "en" => topp_english,
            "ca" => "Topp CA",
            "es" => "Topp ES"
          }
        end

        let(:attributes) do
          {
            "questionnaire" => {
              "tos" => tos,
              "title" => title,
              "description" => description,
              "questions" => questions,
              "topp" => topp,
              "collect_user_data" => collect_user_data
            }
          }
        end

        context "when everything is OK" do
          it { is_expected.to be_valid }
        end

        context "when a question is not valid" do
          let(:body_english) { "" }

          it { is_expected.not_to be_valid }
        end

        context "when tos is not valid" do
          let(:tos_english) { "" }

          it { is_expected.not_to be_valid }
        end

        context "when collecting user data" do
          let(:collect_user_data) { "1" }

          context "and topp is blank" do
            let(:topp_english) { "" }

            it { is_expected.not_to be_valid }
          end

          context "and topp is present" do
            let(:topp_english) { "<p>Terms of privacy policy" }

            it { is_expected.to be_valid }
          end
        end
      end
    end
  end
end
