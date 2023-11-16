require 'rails_helper'

module Decidim::Govbr
  RSpec.describe PromotedToAdminMailer do
    include ActionView::Helpers::SanitizeHelper

    let(:organization) { create(:organization) }
    let(:participatory_process) { create(:participatory_process, organization: organization) }
    let(:user) { create(:user, organization: organization, locale: :'pt-BR') }
    let(:mail) { described_class.notification(user) }

    describe '.notification' do
      context 'when it is called with a valid user sends email' do
        it 'to the user email address' do
          expect(mail.to).to eq([user.email])
        end

        it 'with the correct subject' do
          expect(mail.subject).to eq("#{organization.name} - Você foi promovido(a) a administrador(a)")
        end

        it 'containing information about the user promotion' do
          I18n.with_locale(:'pt-BR') do
            expect(email_body(mail)).to have_tag('p', :seen => "Olá, #{user.name}!")
            expect(email_body(mail)).to have_tag('p', :seen => "Informamos que seu usuário foi promovido a administrador da plataforma #{organization.name}. Este é um e-mail automático e não deve ser respondido.")
          end
        end
      end
    end
  end
end