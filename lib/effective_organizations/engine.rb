module EffectiveOrganizations
  class Engine < ::Rails::Engine
    engine_name 'effective_organizations'

    # Set up our default configuration options.
    initializer 'effective_organizations.defaults', before: :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_organizations.rb")
    end

    # Include acts_as_addressable concern and allow any ActiveRecord object to call it
    initializer 'effective_organizations.active_record' do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.extend(EffectiveOrganizationsUser::Base)
      end
    end

  end
end
