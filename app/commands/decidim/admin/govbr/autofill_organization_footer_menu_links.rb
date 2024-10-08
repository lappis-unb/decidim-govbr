# frozen_string_literal: true

module Decidim
  module Admin
    module Govbr
      class AutofillOrganizationFooterMenuLinks < Decidim::Command
        attr_reader :current_user, :current_organization

        def initialize(user)
          @current_user = user
          @current_organization = user.organization
        end

        # Public: Creates the Component.
        #
        # Broadcasts :ok if created, :invalid otherwise.
        def call
          update_organization ? broadcast(:ok, @organization) : broadcast(:invalid)
        end

        private

        def generate_menu_links
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
        end

        def update_organization
          @organization = Decidim.traceability.update!(
            current_organization,
            current_user,
            footer_menu_links: generate_menu_links
          )
        end
      end
    end
  end
end
