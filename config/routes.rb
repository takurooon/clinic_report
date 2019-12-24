Rails.application.routes.draw do

  root 'reports#home'
  get 'my_page/index'
  
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }
  
  get 'my_page' => 'my_page#index'
  get 'my_page/draft' => 'reports#draft'
  
  resources :users, shallow: true do
    resources :reports, only: %[index]
  end
  
  resources :reports do
    collection do
      post :confirm
    end
    resource :likes, only: [:create, :destroy]
  end

  resources :clinics
  
  get "cities_select" => "clinics#cities_select"
  get "clinics_select" => "clinics#clinics_select"
  
  resources :comments, only: %i[create destroy]
  # resources :clinic_reviews, only: %i[index]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

# == Route Map
#
#                                Prefix Verb   URI Pattern                                                                              Controller#Action
#                         my_page_index GET    /my_page/index(.:format)                                                                 my_page#index
#                                  root GET    /                                                                                        reports#home
#                      new_user_session GET    /users/sign_in(.:format)                                                                 users/sessions#new
#                          user_session POST   /users/sign_in(.:format)                                                                 users/sessions#create
#                  destroy_user_session DELETE /users/sign_out(.:format)                                                                users/sessions#destroy
#                     new_user_password GET    /users/password/new(.:format)                                                            users/passwords#new
#                    edit_user_password GET    /users/password/edit(.:format)                                                           users/passwords#edit
#                         user_password PATCH  /users/password(.:format)                                                                users/passwords#update
#                                       PUT    /users/password(.:format)                                                                users/passwords#update
#                                       POST   /users/password(.:format)                                                                users/passwords#create
#              cancel_user_registration GET    /users/cancel(.:format)                                                                  users/registrations#cancel
#                 new_user_registration GET    /users/sign_up(.:format)                                                                 users/registrations#new
#                edit_user_registration GET    /users/edit(.:format)                                                                    users/registrations#edit
#                     user_registration PATCH  /users(.:format)                                                                         users/registrations#update
#                                       PUT    /users(.:format)                                                                         users/registrations#update
#                                       DELETE /users(.:format)                                                                         users/registrations#destroy
#                                       POST   /users(.:format)                                                                         users/registrations#create
#                 new_user_confirmation GET    /users/confirmation/new(.:format)                                                        users/confirmations#new
#                     user_confirmation GET    /users/confirmation(.:format)                                                            users/confirmations#show
#                                       POST   /users/confirmation(.:format)                                                            users/confirmations#create
#                               my_page GET    /my_page(.:format)                                                                       my_page#index
#                         my_page_draft GET    /my_page/draft(.:format)                                                                 reports#draft
#                          user_reports GET    /users/:user_id/reports(.:format)                                                        reports#index
#                                 users GET    /users(.:format)                                                                         users#index
#                                       POST   /users(.:format)                                                                         users#create
#                              new_user GET    /users/new(.:format)                                                                     users#new
#                             edit_user GET    /users/:id/edit(.:format)                                                                users#edit
#                                  user GET    /users/:id(.:format)                                                                     users#show
#                                       PATCH  /users/:id(.:format)                                                                     users#update
#                                       PUT    /users/:id(.:format)                                                                     users#update
#                                       DELETE /users/:id(.:format)                                                                     users#destroy
#                       confirm_reports POST   /reports/confirm(.:format)                                                               reports#confirm
#                          report_likes DELETE /reports/:report_id/likes(.:format)                                                      likes#destroy
#                                       POST   /reports/:report_id/likes(.:format)                                                      likes#create
#                               reports GET    /reports(.:format)                                                                       reports#index
#                                       POST   /reports(.:format)                                                                       reports#create
#                            new_report GET    /reports/new(.:format)                                                                   reports#new
#                           edit_report GET    /reports/:id/edit(.:format)                                                              reports#edit
#                                report GET    /reports/:id(.:format)                                                                   reports#show
#                                       PATCH  /reports/:id(.:format)                                                                   reports#update
#                                       PUT    /reports/:id(.:format)                                                                   reports#update
#                                       DELETE /reports/:id(.:format)                                                                   reports#destroy
#                              comments POST   /comments(.:format)                                                                      comments#create
#                               comment DELETE /comments/:id(.:format)                                                                  comments#destroy
#                     letter_opener_web        /letter_opener                                                                           LetterOpenerWeb::Engine
#         rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                  action_mailbox/ingresses/mandrill/inbound_emails#create
#         rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                  action_mailbox/ingresses/postmark/inbound_emails#create
#            rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                     action_mailbox/ingresses/relay/inbound_emails#create
#         rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                  action_mailbox/ingresses/sendgrid/inbound_emails#create
#          rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                              action_mailbox/ingresses/mailgun/inbound_emails#create
#        rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#index
#                                       POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#create
#     new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                             rails/conductor/action_mailbox/inbound_emails#new
#    edit_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                        rails/conductor/action_mailbox/inbound_emails#edit
#         rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#show
#                                       PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#destroy
# rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                      rails/conductor/action_mailbox/reroutes#create
#                    rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#             rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#                    rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#             update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#                  rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
# 
# Routes for LetterOpenerWeb::Engine:
# clear_letters DELETE /clear(.:format)                 letter_opener_web/letters#clear
# delete_letter DELETE /:id(.:format)                   letter_opener_web/letters#destroy
#       letters GET    /                                letter_opener_web/letters#index
#        letter GET    /:id(/:style)(.:format)          letter_opener_web/letters#show
#               GET    /:id/attachments/:file(.:format) letter_opener_web/letters#attachment
