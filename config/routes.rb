# == Route Map
#
#                Prefix Verb   URI Pattern                                                 Controller#Action
#                  root GET    /                                                           dashboard#index
#    project_activities POST   /projects/:project_id/activities/:type(.:format)            activities#create {:owner=>"project"}
#      project_activity GET    /projects/:project_id/activities/:type/:id(.:format)        activities#show {:owner=>"project"}
#        follow_project PUT    /projects/:id/follow(.:format)                              projects#follow
#      unfollow_project PUT    /projects/:id/unfollow(.:format)                            projects#unfollow
#          like_project PUT    /projects/:id/like(.:format)                                projects#like
#        unlike_project PUT    /projects/:id/unlike(.:format)                              projects#unlike
#              projects GET    /projects(.:format)                                         projects#index
#                       POST   /projects(.:format)                                         projects#create
#           new_project GET    /projects/new(.:format)                                     projects#new
#          edit_project GET    /projects/:id/edit(.:format)                                projects#edit
#               project GET    /projects/:id(.:format)                                     projects#show
#                       PATCH  /projects/:id(.:format)                                     projects#update
#                       PUT    /projects/:id(.:format)                                     projects#update
#                       DELETE /projects/:id(.:format)                                     projects#destroy
#     person_activities POST   /people/:person_id/activities/:type(.:format)               activities#create {:owner=>"person"}
#       person_activity GET    /people/:person_id/activities/:type/:id(.:format)           activities#show {:owner=>"person"}
#         follow_person PUT    /people/:id/follow(.:format)                                people#follow
#       unfollow_person PUT    /people/:id/unfollow(.:format)                              people#unfollow
#           like_person PUT    /people/:id/like(.:format)                                  people#like
#         unlike_person PUT    /people/:id/unlike(.:format)                                people#unlike
#                people GET    /people(.:format)                                           people#index
#                       POST   /people(.:format)                                           people#create
#            new_person GET    /people/new(.:format)                                       people#new
#           edit_person GET    /people/:id/edit(.:format)                                  people#edit
#                person GET    /people/:id(.:format)                                       people#show
#                       PATCH  /people/:id(.:format)                                       people#update
#                       PUT    /people/:id(.:format)                                       people#update
#                       DELETE /people/:id(.:format)                                       people#destroy
# technology_activities POST   /technologies/:technology_id/activities/:type(.:format)     activities#create {:owner=>"technology"}
#   technology_activity GET    /technologies/:technology_id/activities/:type/:id(.:format) activities#show {:owner=>"technology"}
#     follow_technology PUT    /technologies/:id/follow(.:format)                          technologies#follow
#   unfollow_technology PUT    /technologies/:id/unfollow(.:format)                        technologies#unfollow
#       like_technology PUT    /technologies/:id/like(.:format)                            technologies#like
#     unlike_technology PUT    /technologies/:id/unlike(.:format)                          technologies#unlike
#          technologies GET    /technologies(.:format)                                     technologies#index
#                       POST   /technologies(.:format)                                     technologies#create
#        new_technology GET    /technologies/new(.:format)                                 technologies#new
#       edit_technology GET    /technologies/:id/edit(.:format)                            technologies#edit
#            technology GET    /technologies/:id(.:format)                                 technologies#show
#                       PATCH  /technologies/:id(.:format)                                 technologies#update
#                       PUT    /technologies/:id(.:format)                                 technologies#update
#                       DELETE /technologies/:id(.:format)                                 technologies#destroy
#         follow_client PUT    /clients/:id/follow(.:format)                               clients#follow
#       unfollow_client PUT    /clients/:id/unfollow(.:format)                             clients#unfollow
#           like_client PUT    /clients/:id/like(.:format)                                 clients#like
#         unlike_client PUT    /clients/:id/unlike(.:format)                               clients#unlike
#               clients GET    /clients(.:format)                                          clients#index
#                       POST   /clients(.:format)                                          clients#create
#            new_client GET    /clients/new(.:format)                                      clients#new
#           edit_client GET    /clients/:id/edit(.:format)                                 clients#edit
#                client GET    /clients/:id(.:format)                                      clients#show
#                       PATCH  /clients/:id(.:format)                                      clients#update
#                       PUT    /clients/:id(.:format)                                      clients#update
#                       DELETE /clients/:id(.:format)                                      clients#destroy
#      new_user_session GET    /users/sign_in(.:format)                                    devise/sessions#new
#          user_session POST   /users/sign_in(.:format)                                    devise/sessions#create
#  destroy_user_session DELETE /users/sign_out(.:format)                                   devise/sessions#destroy
#            refile_app        /attachments                                                #<Refile::App app_file="/home/john/.rvm/gems/ruby-2.2.2@enlighten/gems/refile-0.6.1/lib/refile/app.rb">
#

Rails.application.routes.draw do
  root 'cards#index'

  concern :followable do
    member do
      put :follow
      put :unfollow
    end
  end

  concern :likable do
    member do
      put :like
      put :unlike
    end
  end

  concern :cardable do
    collection do
      get :cards
    end

    member do
      get :card
    end
  end

  resources :projects, concerns: [:followable, :likable, :cardable] do
    resources :activities, path: 'activities/:type', only: [:show, :create], defaults: { owner: 'project' }
  end

  resources :people, concerns: [:followable, :likable, :cardable] do
    resources :activities, path: 'activities/:type', only: [:show, :create], defaults: { owner: 'person' }
  end

  resources :technologies, concerns: [:followable, :likable, :cardable] do
    resources :activities, path: 'activities/:type', only: [:show, :create], defaults: { owner: 'technology' }
  end

  resources :clients, concerns: [:followable, :likable, :cardable]

  resources :cards, concerns: [:followable, :likable, :cardable]

  devise_for :users
end
