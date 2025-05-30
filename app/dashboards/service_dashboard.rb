require "administrate/base_dashboard"

class ServiceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    active: Field::Boolean,
    children: Field::HasMany,
    closed: Field::Boolean,
    closing_days: Field::HasMany,
    company: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ["name"],
      scope: -> { AdministrateHelper.scoped_companies(Thread.current[:scope]) }
    ),
    counters: Field::HasMany,
    letter: Field::String,
    max_quota: Field::Number,
    max_service_time: Field::Number,
    name: Field::String,
    parent: Field::BelongsTo.with_options(
      scope: -> { AdministrateHelper.scoped_services(Thread.current[:scope]) }
    ),
    priority: Field::Boolean,
    service_type: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ["name"],
      scope: -> { AdministrateHelper.scoped_service_types(Thread.current[:scope]) }
    ),
    shared_clientdisplays: Field::HasMany,
    versions: Field::HasMany,
    working_days: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    deleted_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    company
    service_type
    letter
    name
    max_quota
    max_service_time
    priority
    closed
    active
    parent
    working_days
    closing_days
    counters
    shared_clientdisplays
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    company
    service_type
    letter
    name
    max_quota
    max_service_time
    priority
    closed
    active
    parent
    working_days
    closing_days
    counters
    shared_clientdisplays
    created_at
    updated_at
    deleted_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    company
    service_type
    letter
    name
    max_quota
    max_service_time
    priority
    closed
    active
    parent
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how services are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(service)
    service.name
  end
end
