require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    confirmation_sent_at: Field::DateTime,
    confirmation_token: Field::String,
    confirmed_at: Field::DateTime,
    company: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ["name"]
    ),
    current_sign_in_at: Field::DateTime,
    current_sign_in_ip: Field::String,
    email: Field::String,
    encrypted_password: Field::String,
    failed_attempts: Field::Number,
    last_sign_in_at: Field::DateTime,
    last_sign_in_ip: Field::String,
    locked_at: Field::DateTime,
    name: Field::String,
    otp_auth_secret: Field::String,
    otp_challenge_expires: Field::DateTime,
    otp_enabled: Field::Boolean,
    otp_enabled_on: Field::DateTime,
    otp_failed_attempts: Field::Number,
    otp_mandatory: Field::Boolean,
    otp_persistence_seed: Field::String,
    otp_recovery_counter: Field::Number,
    otp_recovery_secret: Field::String,
    otp_session_challenge: Field::String,
    phone_number: Field::String,
    password: Field::Password,
    password_confirmation: Field::Password,
    refresh_token: Field::String,
    refresh_token_created_at: Field::DateTime,
    remember_created_at: Field::DateTime,
    reset_password_sent_at: Field::DateTime,
    reset_password_token: Field::String,
    sign_in_count: Field::Number,
    unconfirmed_email: Field::String,
    unlock_token: Field::String,
    user_counters: Field::HasMany,
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
    email
    name
    phone_number
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    company
    name
    email
    confirmation_sent_at
    confirmation_token
    confirmed_at
    current_sign_in_at
    current_sign_in_ip
    encrypted_password
    failed_attempts
    last_sign_in_at
    last_sign_in_ip
    locked_at
    otp_auth_secret
    otp_challenge_expires
    otp_enabled
    otp_enabled_on
    otp_failed_attempts
    otp_mandatory
    otp_persistence_seed
    otp_recovery_counter
    otp_recovery_secret
    otp_session_challenge
    phone_number
    refresh_token
    refresh_token_created_at
    remember_created_at
    reset_password_sent_at
    reset_password_token
    sign_in_count
    unconfirmed_email
    unlock_token
    user_counters
    created_at
    updated_at
    deleted_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    company
    email
    name
    phone_number
    password
    password_confirmation
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

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    user.name
  end
end
