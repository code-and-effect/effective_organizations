# frozen_string_literal: true

Rails.application.routes.draw do
  mount EffectiveOrganizations::Engine => '/', as: 'effective_organizations'
end

EffectiveOrganizations::Engine.routes.draw do
  # Public routes
  scope module: 'effective' do
    resources :organizations, except: [:show, :destroy]
    resources :representatives, except: [:show]
  end

  namespace :admin do
    resources :organizations, except: [:show]
    resources :representatives, except: [:show]
  end

end
