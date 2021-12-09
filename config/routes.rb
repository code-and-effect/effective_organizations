Rails.application.routes.draw do
  mount EffectiveOrganizations::Engine => '/', as: 'effective_organizations'
end

EffectiveOrganizations::Engine.routes.draw do
  # Public routes
  scope module: 'effective' do
  end

  namespace :admin do
  end

end
