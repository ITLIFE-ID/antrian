require "administrate/base_dashboard"

class UserSatisfactionIndexDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    officer_name: Field::String,
    rating: Field::Number,
    review: Field::String,
    satifcation_index_name: Field::String,
    satisfaction_index: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ["name"],
      scope: -> { AdministrateHelper.scoped_satisfaction_indices(Thread.current[:scope]) }
    ),
    today_queue: Field::BelongsTo,
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
    today_queue
    satifcation_index_name
    rating
    review
    officer_name
    rating
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    today_queue
    satifcation_index_name
    rating
    review
    officer_name
    rating
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

  # Overwrite this method to customize how user satisfaction indices are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user_satisfaction_index)
  #   "UserSatisfactionIndex ##{user_satisfaction_index.id}"
  # end
end
