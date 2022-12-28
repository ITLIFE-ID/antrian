require "administrate/base_dashboard"

class BackupQueueDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    attend: Field::Boolean,
    children: Field::HasMany,
    counter: Field::BelongsTo,
    date: Field::Date,
    finish_time: Field::DateTime,
    letter: Field::String,
    note: Field::String,
    number: Field::Number,
    parent: Field::BelongsTo,
    print_ticket_location: Field::String,
    print_ticket_method: Field::String,
    print_ticket_time: Field::DateTime,
    priority: Field::Boolean,
    process_duration: Field::Number,
    service: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ["name"],
      scope: -> { AdministrateHelper.scoped_services(Thread.current[:scope]) }
    ),
    service_type_slug: Field::String,
    start_time: Field::DateTime,
    uniq_number: Field::String,
    versions: Field::HasMany,
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
    letter
    number
    date
    counter
    service
    print_ticket_time
    start_time
    finish_time
    print_ticket_location
    print_ticket_method
    priority
    process_duration
    parent
    attend
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    letter
    number
    date
    counter
    service
    print_ticket_time
    start_time
    finish_time
    print_ticket_location
    print_ticket_method
    priority
    process_duration
    parent
    attend
    note
    service_type_slug
    uniq_number
    created_at
    updated_at
    deleted_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[].freeze

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

  # Overwrite this method to customize how backup queues are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(backup_queue)
  #   "BackupQueue ##{backup_queue.id}"
  # end
end
