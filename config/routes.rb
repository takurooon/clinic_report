Rails.application.routes.draw do

  root 'reports#index'
  get 'my_page' => 'my_page#index'
  get 'my_page/draft' => 'reports#draft'
  get 'thanks' => 'my_page#thanks'
  get 'category/search' => 'searches#search'
  get 'category/amh' => 'searches#all_amh'
  get 'category/amh/:value' => 'searches#amh'
  get 'category/clinics' => 'searches#clinics'
  get 'category/clinics/:value' => 'searches#clinic'
  get 'category/clinics/prefecture/:value' => 'searches#clinic_prefecture'
  get 'category/clinics/city/:value' => 'searches#clinic_city'
  get 'category/age' => 'searches#all_age'
  get 'category/age/:value' => 'searches#age'
  get 'category/tags' => 'searches#tags'
  get ':category/:tags/:gender/:value' => 'searches#tag'
  get 'category/area' => 'searches#all_area'
  get 'category/prefecture/:value' => 'searches#area_prefecture'
  get 'category/city/:value' => 'searches#area_city'
  get 'about' => 'application#about'
  get 'terms' => 'application#terms'
  get 'privacy' => 'application#privacy'
  get 'admin' => 'application#admin'

  devise_for :users, path: '', controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
  }

  # ゲストログイン機能(参考: https://qiita.com/take18k_tech/items/35f9b5883f5be4c6e104)
  # devise_scope :user do
    # post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  # end
  # ここまで(ゲストログイン機能)

  resources :users, shallow: true do
    resources :reports, only: %[index]
  end
  
  resources :reports do
    collection do
      post :confirm
    end
    member do
      patch :confirm
      patch :release
      patch :nonrelease
    end
    resource :likes, only: [:create, :destroy]
  end

  resources :clinics
  
  get "cities_select" => "clinics#cities_select"
  get "clinics_select" => "clinics#clinics_select"
  get "clinic_select" => "clinics#clinic_select"
  get "address_cities_select" => "reports#address_cities_select"
  
  resources :comments, only: %i[create destroy]

  resources :notifications, only: :index

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

# == Route Map
#
#                                Prefix Verb   URI Pattern                                                                              Controller#Action
#                                  root GET    /                                                                                        reports#index
#                               my_page GET    /my_page(.:format)                                                                       my_page#index
#                         my_page_draft GET    /my_page/draft(.:format)                                                                 reports#draft
#                                thanks GET    /thanks(.:format)                                                                        my_page#thanks
#                       category_search GET    /category/search(.:format)                                                               searches#search
#                          category_amh GET    /category/amh(.:format)                                                                  searches#all_amh
#                                       GET    /category/amh/:value(.:format)                                                           searches#amh
#                      category_clinics GET    /category/clinics(.:format)                                                              searches#clinics
#                                       GET    /category/clinics/:value(.:format)                                                       searches#clinic
#                                       GET    /category/clinics/prefecture/:value(.:format)                                            searches#clinic_prefecture
#                                       GET    /category/clinics/city/:value(.:format)                                                  searches#clinic_city
#                          category_age GET    /category/age(.:format)                                                                  searches#all_age
#                                       GET    /category/age/:value(.:format)                                                           searches#age
#                         category_tags GET    /category/tags(.:format)                                                                 searches#tags
#                                       GET    /:category/:tags/:gender/:value(.:format)                                                searches#tag
#                         category_area GET    /category/area(.:format)                                                                 searches#all_area
#                                       GET    /category/prefecture/:value(.:format)                                                    searches#area_prefecture
#                                       GET    /category/city/:value(.:format)                                                          searches#area_city
#                                 about GET    /about(.:format)                                                                         application#about
#                                 terms GET    /terms(.:format)                                                                         application#terms
#                               privacy GET    /privacy(.:format)                                                                       application#privacy
#                                 admin GET    /admin(.:format)                                                                         application#admin
#                      new_user_session GET    /sign_in(.:format)                                                                       users/sessions#new
#                          user_session POST   /sign_in(.:format)                                                                       users/sessions#create
#                  destroy_user_session DELETE /sign_out(.:format)                                                                      users/sessions#destroy
#                     new_user_password GET    /password/new(.:format)                                                                  users/passwords#new
#                    edit_user_password GET    /password/edit(.:format)                                                                 users/passwords#edit
#                         user_password PATCH  /password(.:format)                                                                      users/passwords#update
#                                       PUT    /password(.:format)                                                                      users/passwords#update
#                                       POST   /password(.:format)                                                                      users/passwords#create
#              cancel_user_registration GET    /cancel(.:format)                                                                        users/registrations#cancel
#                 new_user_registration GET    /sign_up(.:format)                                                                       users/registrations#new
#                edit_user_registration GET    /edit(.:format)                                                                          users/registrations#edit
#                     user_registration PATCH  /                                                                                        users/registrations#update
#                                       PUT    /                                                                                        users/registrations#update
#                                       DELETE /                                                                                        users/registrations#destroy
#                                       POST   /                                                                                        users/registrations#create
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
#                        confirm_report PATCH  /reports/:id/confirm(.:format)                                                           reports#confirm
#                        release_report PATCH  /reports/:id/release(.:format)                                                           reports#release
#                     nonrelease_report PATCH  /reports/:id/nonrelease(.:format)                                                        reports#nonrelease
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
#                               clinics GET    /clinics(.:format)                                                                       clinics#index
#                                       POST   /clinics(.:format)                                                                       clinics#create
#                            new_clinic GET    /clinics/new(.:format)                                                                   clinics#new
#                           edit_clinic GET    /clinics/:id/edit(.:format)                                                              clinics#edit
#                                clinic GET    /clinics/:id(.:format)                                                                   clinics#show
#                                       PATCH  /clinics/:id(.:format)                                                                   clinics#update
#                                       PUT    /clinics/:id(.:format)                                                                   clinics#update
#                                       DELETE /clinics/:id(.:format)                                                                   clinics#destroy
#                         cities_select GET    /cities_select(.:format)                                                                 clinics#cities_select
#                        clinics_select GET    /clinics_select(.:format)                                                                clinics#clinics_select
#                         clinic_select GET    /clinic_select(.:format)                                                                 clinics#clinic_select
#                 address_cities_select GET    /address_cities_select(.:format)                                                         reports#address_cities_select
#                              comments POST   /comments(.:format)                                                                      comments#create
#                               comment DELETE /comments/:id(.:format)                                                                  comments#destroy
#                         notifications GET    /notifications(.:format)                                                                 notifications#index
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
