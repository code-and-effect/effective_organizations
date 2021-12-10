module Admin
  class OrganizationsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_organizations) }

    include Effective::CrudController

    resource_scope -> { EffectiveOrganizations.Organization.deep.all }
    datatable -> { Admin::EffectiveOrganizationsDatatable.new }

    private

    def permitted_params
      model = (params.key?(:effective_organization) ? :effective_organization : :organization)
      params.require(model).permit!
    end

  end
end
