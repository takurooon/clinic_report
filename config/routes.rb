Rails.application.routes.draw do

  root 'reports#index'
  get 'my_page' => 'my_page#index'
  get 'my_page/draft' => 'reports#draft'
  get 'thanks' => 'my_page#thanks'
  get 'search' => 'searches#search'
  get 'age' => 'searches#all_age'
  get 'age/:value' => 'searches#age'
  get 'amh' => 'searches#all_amh'
  get 'amh/:value' => 'searches#amh'
  get 'status' => 'searches#all_status'
  get 'status/:value' => 'searches#status'
  get 'search/clinics' => 'searches#clinics'

  get 'clinics_area' => 'searches#clinics_area'
  # get 'clinics_area/prefecture/:value' => 'searches#clinic_prefecture_area'
  get 'clinics_area/:prefecture' => 'clinics#prefecture'
  # get 'clinics_area/city/:value' => 'searches#clinic_city_area'
  get 'clinics_area/:prefecture/:value' => 'clinics#city'
  get 'tags' => 'searches#tags'
  get 'tags/:type/:value' => 'searches#tag'

  get 'count' => 'searches#count'
  get 'count/:type/:value' => 'searches#sairan_ishoku_count'
  get 'works' => 'searches#works'
  get 'work/:value' => 'searches#work'
  get 'costs' => 'searches#costs'
  get 'cost/:value' => 'searches#cost'
  get 'about' => 'application#about'
  get 'terms' => 'application#terms'
  get 'privacy' => 'application#privacy'
  get 'guideline' => 'application#guideline'
  get 'repoco' => 'application#repoco'
  get 'terminology' => 'application#terminology'
  get 'faq' => 'application#faq'
  get 'make' => 'application#make'
  get 'hack' => 'application#hack'
  get 'statistic' => 'application#statistic'

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

  resources :users
    put "/users/:id/hide" => "users#hide", as: 'users_hide'

    # centerの各レポコ中央部のuserの住まい,(prefecture, city)のリンク↓
    get 'users_area' => 'users#all_area'
    get 'users_/:prefecture' => 'users#area_prefecture'
    get 'users_/:prefecture/:city' => 'users#area_city'
    get "cities_select_area" => "users#cities_select_area"
    # ここまで

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

  # centerの各レポコ下部のclinic, prefecture, cityのリンク↓
  get 'clinic/:value' => 'clinics#clinic_report'
  get 'clinics_/:prefecture' => 'clinics#prefecture'
  get 'clinics/:prefecture/:value' => 'clinics#city'
  # ここまで

  # formでも利用
  get "cities_select" => "searches#cities_select_clinics"
  get "clinics_select" => "searches#clinics_select"
  # ここまで

  get "clinic_select" => "searches#clinic_select"

  get "address_cities_select" => "reports#address_cities_select"
  
  resources :comments, only: %i[create destroy]

  resources :notifications, only: :index

  namespace :admin do
    resources :users
    resources :reports
    resources :clinics
    root 'admin#home'
  end

  get "signup" => "reports#signup"

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
#                                search GET    /search(.:format)                                                                        searches#search
#                                   age GET    /age(.:format)                                                                           searches#all_age
#                                       GET    /age/:value(.:format)                                                                    searches#age
#                                   amh GET    /amh(.:format)                                                                           searches#all_amh
#                                       GET    /amh/:value(.:format)                                                                    searches#amh
#                                status GET    /status(.:format)                                                                        searches#all_status
#                                       GET    /status/:value(.:format)                                                                 searches#status
#                        search_clinics GET    /search/clinics(.:format)                                                                searches#clinics
#                 category_clinics_area GET    /category/clinics_area(.:format)                                                         searches#clinics_area
#                                       GET    /category/clinics_area/prefecture/:value(.:format)                                       searches#clinic_prefecture_area
#                                       GET    /category/clinics_area/city/:value(.:format)                                             searches#clinic_city_area
#                         category_tags GET    /category/tags(.:format)                                                                 searches#tags
#                                       GET    /:category/:tags/:gender/:value(.:format)                                                searches#tag
#                                 works GET    /works(.:format)                                                                         searches#works
#                                       GET    /work/:value(.:format)                                                                   searches#work
#                                 costs GET    /costs(.:format)                                                                         searches#costs
#                                       GET    /cost/:value(.:format)                                                                   searches#cost
#                                 about GET    /about(.:format)                                                                         application#about
#                                 terms GET    /terms(.:format)                                                                         application#terms
#                               privacy GET    /privacy(.:format)                                                                       application#privacy
#                             guideline GET    /guideline(.:format)                                                                     application#guideline
#                                repoco GET    /repoco(.:format)                                                                        application#repoco
#                           terminology GET    /terminology(.:format)                                                                   application#terminology
#                                   faq GET    /faq(.:format)                                                                           application#faq
#                                  make GET    /make(.:format)                                                                          application#make
#                                  hack GET    /hack(.:format)                                                                          application#hack
#                             statistic GET    /statistic(.:format)                                                                     application#statistic
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
#                 new_user_confirmation GET    /confirmation/new(.:format)                                                              users/confirmations#new
#                     user_confirmation GET    /confirmation(.:format)                                                                  users/confirmations#show
#                                       POST   /confirmation(.:format)                                                                  users/confirmations#create
#                                 users GET    /users(.:format)                                                                         users#index
#                                       POST   /users(.:format)                                                                         users#create
#                              new_user GET    /users/new(.:format)                                                                     users#new
#                             edit_user GET    /users/:id/edit(.:format)                                                                users#edit
#                                  user GET    /users/:id(.:format)                                                                     users#show
#                                       PATCH  /users/:id(.:format)                                                                     users#update
#                                       PUT    /users/:id(.:format)                                                                     users#update
#                                       DELETE /users/:id(.:format)                                                                     users#destroy
#                            users_hide PUT    /users/:id/hide(.:format)                                                                users#hide
#                            users_area GET    /users_area(.:format)                                                                    users#all_area
#                                       GET    /users_/:prefecture(.:format)                                                            users#area_prefecture
#                                       GET    /users_/:prefecture/:city(.:format)                                                      users#area_city
#                    cities_select_area GET    /cities_select_area(.:format)                                                            users#cities_select_area
#                          user_reports GET    /users/:user_id/reports(.:format)                                                        reports#index
#                                       GET    /users(.:format)                                                                         users#index
#                                       POST   /users(.:format)                                                                         users#create
#                                       GET    /users/new(.:format)                                                                     users#new
#                                       GET    /users/:id/edit(.:format)                                                                users#edit
#                                       GET    /users/:id(.:format)                                                                     users#show
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
#                                       GET    /clinics/:prefecture/:value(.:format)                                                    clinics#city
#                                       GET    /clinic/:value(.:format)                                                                 clinics#clinic_report
#                                       GET    /clinics_/:prefecture(.:format)                                                          clinics#prefecture
#                                       GET    /clinics/:prefecture/:value(.:format)                                                    clinics#city
#                         cities_select GET    /cities_select(.:format)                                                                 searches#cities_select_clinics
#                        clinics_select GET    /clinics_select(.:format)                                                                searches#clinics_select
#                         clinic_select GET    /clinic_select(.:format)                                                                 searches#clinic_select
#                 address_cities_select GET    /address_cities_select(.:format)                                                         reports#address_cities_select
#                              comments POST   /comments(.:format)                                                                      comments#create
#                               comment DELETE /comments/:id(.:format)                                                                  comments#destroy
#                         notifications GET    /notifications(.:format)                                                                 notifications#index
#                           admin_users GET    /admin/users(.:format)                                                                   admin/users#index
#                                       POST   /admin/users(.:format)                                                                   admin/users#create
#                        new_admin_user GET    /admin/users/new(.:format)                                                               admin/users#new
#                       edit_admin_user GET    /admin/users/:id/edit(.:format)                                                          admin/users#edit
#                            admin_user GET    /admin/users/:id(.:format)                                                               admin/users#show
#                                       PATCH  /admin/users/:id(.:format)                                                               admin/users#update
#                                       PUT    /admin/users/:id(.:format)                                                               admin/users#update
#                                       DELETE /admin/users/:id(.:format)                                                               admin/users#destroy
#                         admin_reports GET    /admin/reports(.:format)                                                                 admin/reports#index
#                                       POST   /admin/reports(.:format)                                                                 admin/reports#create
#                      new_admin_report GET    /admin/reports/new(.:format)                                                             admin/reports#new
#                     edit_admin_report GET    /admin/reports/:id/edit(.:format)                                                        admin/reports#edit
#                          admin_report GET    /admin/reports/:id(.:format)                                                             admin/reports#show
#                                       PATCH  /admin/reports/:id(.:format)                                                             admin/reports#update
#                                       PUT    /admin/reports/:id(.:format)                                                             admin/reports#update
#                                       DELETE /admin/reports/:id(.:format)                                                             admin/reports#destroy
#                         admin_clinics GET    /admin/clinics(.:format)                                                                 admin/clinics#index
#                                       POST   /admin/clinics(.:format)                                                                 admin/clinics#create
#                      new_admin_clinic GET    /admin/clinics/new(.:format)                                                             admin/clinics#new
#                     edit_admin_clinic GET    /admin/clinics/:id/edit(.:format)                                                        admin/clinics#edit
#                          admin_clinic GET    /admin/clinics/:id(.:format)                                                             admin/clinics#show
#                                       PATCH  /admin/clinics/:id(.:format)                                                             admin/clinics#update
#                                       PUT    /admin/clinics/:id(.:format)                                                             admin/clinics#update
#                                       DELETE /admin/clinics/:id(.:format)                                                             admin/clinics#destroy
#                            admin_root GET    /admin(.:format)                                                                         admin/admin#home
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
