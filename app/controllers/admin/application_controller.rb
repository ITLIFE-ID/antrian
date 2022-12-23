# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :set_paper_trail_whodunnit
    add_breadcrumb "Home", :admin_root_path
    # before_action :authenticate_administrator!

    def new
      add_breadcrumb I18n.t("new")
      super
    end

    def edit
      add_breadcrumb I18n.t("edit")
      super
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
