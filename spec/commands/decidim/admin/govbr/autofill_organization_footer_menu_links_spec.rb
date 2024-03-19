# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Admin
    module Govbr
      describe AutofillOrganizationFooterMenuLinks do
        let(:user) { create(:user, :admin, :confirmed, organization: organization) }
        let(:organization) { create(:organization) }
        let(:command) { described_class.new(user) }

        context "when footer is void" do
          it "only consider footer is full" do
            command.call
            expect(organization.footer_menu_links).to eq(
              {
                "menu" => [
                  {
                    "id" => "inicio",
                    "href" => "/",
                    "label" => "Início",
                    "sub_items" => [],
                    "is_visible" => true,
                    "is_topic" => true
                  },
                  {
                    "id" => "noticia",
                    "href" => "/",
                    "label" => "Notícias",
                    "sub_items" => [],
                    "is_visible" => true,
                    "is_topic" => true
                  },
                  {
                    "id" => "Processos Participativos",
                    "href" => "javascript:void(0)",
                    "label" => "Processos Participativos",
                    "sub_items" => [
                      {
                        "id" => "Conferencias",
                        "href" => "/assemblies/",
                        "label" => "Conferências",
                        "sub_items" => [],
                        "is_visible" => true
                      },
                      {
                        "id" => "PPA",
                        "href" => "/processes/",
                        "label" => "PPA",
                        "sub_items" => [],
                        "is_visible" => true
                      }
                    ],
                    "is_visible" => true,
                    "is_topic" => true
                  },
                  {
                    "id" => "Canais de Atendimento",
                    "href" => "/",
                    "label" => "Canais de Atendimento",
                    "sub_items" => [
                      {
                        "id" => "Fale Conosco",
                        "href" => "https://falabr.cgu.gov.br/web/home",
                        "label" => "Fale Conosco",
                        "sub_items" => [],
                        "is_visible" => true
                      },
                      {
                        "id" => "Ouvidoria",
                        "href" => "https://falabr.cgu.gov.br/web/home?modoOuvidoria=1",
                        "label" => "Ouvidoria",
                        "sub_items" => [],
                        "is_visible" => true
                      },
                      {
                        "id" => "Area de Imprensa",
                        "href" => "https://www.gov.br/planalto/pt-br/acompanhe-o-planalto/area-de-imprensa",
                        "label" => "Area de Imprensa",
                        "sub_items" => [],
                        "is_visible" => true
                      },
                      {
                        "id" => "Serviço de Informação ao Cidadão",
                        "href" => "https://falabr.cgu.gov.br/web/home",
                        "label" => "Serviço de Informação do Cidadão (SIC)",
                        "sub_items" => [],
                        "is_visible" => true
                      }
                    ],
                    "is_visible" => true,
                    "is_topic" => true
                  },
                  {
                    "id" => "sobre",
                    "href" => "javascript:void(0)",
                    "label" => "Sobre",
                    "sub_items" => [
                      {
                        "id" => "Quem Somos",
                        "href" => "/",
                        "label" => "Quem Somos",
                        "sub_items" => [],
                        "is_visible" => true
                      },
                      {
                        "id" => "O que fazemos",
                        "href" => "/",
                        "label" => "O que fazemos",
                        "sub_items" => [],
                        "is_visible" => true
                      },
                      {
                        "id" => "Termos e Condições de Uso",
                        "href" => "/pages/terms-and-conditions",
                        "label" => "Termos e Condições de Uso",
                        "sub_items" => [],
                        "is_visible" => true
                      },
                      {
                        "id" => "Dados Abertos",
                        "href" => "/",
                        "label" => "Dados Abertos",
                        "sub_items" => [],
                        "is_visible" => true
                      }
                    ],
                    "is_visible" => true,
                    "is_topic" => true
                  }
                ]
              }
            )
          end
        end
      end
    end
  end
end
