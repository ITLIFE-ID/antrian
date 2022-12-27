# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    add_breadcrumb "Home", :admin_root_path
    before_action :authenticate_administrator!
    authorize :user, through: :current_administrator
    before_action :set_paper_trail_whodunnit     

    def index      
      super
    end

    def show
      super
    end

    def new
      add_breadcrumb I18n.t("new")
      super
    end

    def edit
      add_breadcrumb I18n.t("edit")
      super
    end

    def create
      resource = authorized_resource.new(resource_params)      

      if resource.save
        redirect_to(
          after_resource_created_path(resource),
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }, status: :unprocessable_entity
      end
    end

    def update
     super
    end

    def destroy
      super
    end

    def scoped_resource
      resource_class
    end

    private
    def authorized_resource      
      authorized_scope(resource_class.all)
    end
    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
