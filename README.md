# Effective Organizations

Users have many organizations through representatives.

## Getting Started

This requires Rails 6+ and Twitter Bootstrap 4 and just works with Devise.

Please first install the [effective_datatables](https://github.com/code-and-effect/effective_datatables) gem.

Please download and install the [Twitter Bootstrap4](http://getbootstrap.com)

Add to your Gemfile:

```ruby
gem 'haml-rails' # or try using gem 'hamlit-rails'
gem 'effective_organizations'
```

Run the bundle command to install it:

```console
bundle install
```

Then run the generator:

```ruby
rails generate effective_organizations:install
```

The generator will install an initializer which describes all configuration options and creates a database migration.

If you want to tweak the table names, manually adjust both the configuration file and the migration now.

Then migrate the database:

```ruby
rake db:migrate
```

Please add the following to your User model:

```
effective_organizations_user

Use the following datatables to display to your user their applicants dues:

```haml
%h2 My Organizations
- datatable = EffectiveOrganizationsDatatable.new(self)
```

and

```
Add a link to the admin menu:

```haml
- if can? :admin, :effective_organizations
  - if can? :index, Effective::Organization
    = nav_link_to 'Organizations', effective_organizations.admin_organizations_path

  - if can? :index, Effective::Representative
    = nav_link_to 'Representatives', effective_organizations.admin_representatives_path
```

## Configuration

## Authorization

All authorization checks are handled via the effective_resources gem found in the `config/initializers/effective_resources.rb` file.

## Effective Roles

This gem works with effective roles for the representative roles.

Configure your `config/initializers/effective_roles.rb` something like this:

```
EffectiveRoles.setup(:caaa) do |config|
  config.roles = [:admin, :reserved, :owner, :billing] # Only add to the end of this array. Never prepend roles.

  # config.role_descriptions
  # ========================
  # This setting configures the text that is displayed by form helpers (see README.md)

  config.role_descriptions = {
    'User' => {
      # User roles
      admin: 'can log in to the /admin section of the website. full access to everything.',
    },
    'Effective::Representative' => {
      owner: 'the owner. full access to everything.',
      billing: 'the billing contact. full access to everything.'
    }
  }

  # config.assignable_roles
  # Which roles can be assigned by whom
  # =======================
  # When current_user is passed into a form helper function (see README.md)
  # this setting determines which roles that current_user may assign
  config.assignable_roles = {
    'User' => { admin: [:admin] },

    'Effective::Representative' => {
      admin: [:owner, :billing],
      owner: [:owner, :billing],
      billing: [:billing]
    }
  }
end
```


## Permissions

The permissions you actually want to define are as follows (using CanCan):

```ruby
if user.persisted?
  can :index, EffectiveOrganizations.Organization
  can(:show, EffectiveOrganizations.Organization) { |organization| user.organizations.include?(organization) }

  can([:edit, :update], EffectiveOrganizations.Organization) do |organization|
    rep = user.representative(organization: organization)
    rep && (rep.is?(:owner) || rep.is?(:billing))
  end

  can :index, Effective::Representative
  can(:new, Effective::Representative)

  can([:create, :edit, :update], Effective::Representative) do |representative|
    rep = user.representative(organization: representative.organization)
    rep && (rep.is?(:owner) || rep.is?(:billing))
  end

  can(:destroy, Effective::Representative) do |representative|
    allowed = !(representative.is?(:owner) || representative.is?(:billing))
    rep = user.representative(organization: representative.organization)

    allowed && rep && (rep.is?(:owner) || rep.is?(:billing))
  end
end

if user.admin?
  can :admin, :effective_organizations
  can(crud, EffectiveOrganizations.Organization)

  can(crud - [:destroy], Effective::Representative)
  can(:destroy, Effective::Representative) { |rep| !rep.is?(:owner) }
end
```

## License

MIT License.  Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)

## Testing

Run tests by:

```ruby
rails test
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request
