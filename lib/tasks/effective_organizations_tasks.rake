namespace :effective_organizations do

  # bundle exec rake effective_organizations:seed
  task seed: :environment do
    load "#{__dir__}/../../db/seeds.rb"
  end

end
