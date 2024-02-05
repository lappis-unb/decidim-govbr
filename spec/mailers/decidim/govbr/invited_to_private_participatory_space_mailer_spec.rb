require 'rails_helper'

module Decidim::Govbr
  RSpec.describe InvitedToPrivateParticipatorySpaceMailer do
    include ActionView::Helpers::SanitizeHelper

    let(:organization) { create(:organization) }
    let(:participatory_process) { create(:participatory_process, organization: organization) }
    let(:user) { create(:user, organization: organization, locale: :'pt-BR') }
    let(:mail) { described_class.notification(user, participatory_process) }

    describe '.notification' do
      context 'when it is called with a valid user and participatory space sends email' do
        it 'to the user email address' do
          expect(mail.to).to eq([user.email])
        end

        it 'with the correct subject' do
          expect(mail.subject).to eq("#{organization.name} - Você foi adicionado(a) a um espaço participativo")
        end

        it 'containing information about the participatory space' do
          I18n.with_locale(:'pt-BR') do
            participatory_space_name = participatory_process.title[:'pt-BR'] = 'Organizacao de Teste'
            expect(email_body(mail)).to have_tag('p', :seen => "Olá, #{user.name}!")
            expect(email_body(mail)).to have_tag('p', :seen => "Informamos que você foi adicionado(a) como participante privado no espaço participativo #{participatory_space_name}. Este é um e-mail automático e não deve ser respondido.")
          end
        end
      end
    end
  end
end