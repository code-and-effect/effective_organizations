# Dashboard Organizations
class EffectiveOrganizationsDatatable < Effective::Datatable
  datatable do
    order :title

    col :id, visible: false

    col :title
    col :representatives

    actions_col
  end

  collection do
    EffectiveOrganizations.Organization.deep.where(id: current_user.organizations)
  end

end
