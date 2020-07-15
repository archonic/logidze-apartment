# frozen_string_literal: true

# You can have Apartment route to the appropriate Tenant by adding some Rack middleware.
# Apartment can support many different "Elevators" that can take care of this routing to your data.
# Require whichever Elevator you're using below or none if you have a custom one.
require "apartment/elevators/subdomain"

# Apartment Configuration
Apartment.configure do |config|
  # Add any models that you do not want to be multi-tenanted, but remain in the global (public) namespace.
  # A typical example would be a Customer or Tenant model that stores each Tenant's information.
  config.excluded_models = %w(
    Account
  )

  config.tenant_names = lambda { Account.pluck :subdomain }
  # Migrate tenants when running migrations
  config.db_migrate_tenants = true

  # PostgreSQL: Specifies whether to use PostgreSQL schemas or create a new database per Tenant.
  config.use_schemas = true

  # Apartment can be forced to use raw SQL dumps instead of schema.rb for creating new schemas.
  # Use this when you are using some extra features in PostgreSQL that can't be represented in
  # schema.rb, like materialized views etc. (only applies with use_schemas set to true).
  # (Note: this option doesn't use db/structure.sql, it creates SQL dump by executing pg_dump)
  config.use_sql = true

  # There are cases where you might want some schemas to always be in your search_path
  # e.g when using a PostgreSQL extension like hstore.
  # Any schemas added here will be available along with your selected Tenant.
  config.persistent_schemas = %w{shared_extensions}
end

Apartment::Elevators::Subdomain.excluded_subdomains = %w(www app admin secure public mail pop smtp ssl sftp reply webdisk cpanel).freeze
Rails.application.config.middleware.use Apartment::Elevators::Subdomain
