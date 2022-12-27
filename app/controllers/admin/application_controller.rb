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
    before_action :set_current_company    

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
      resource = resource_class.new(resource_params)      

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
      child_company_resource
    end

    private

    def set_current_company
      @current_company ||= current_administrator.company
    end

    def scoped_resource_class
      authorized_scope(resource_class.all)
    end

    def child_company_resource
      return resource_class if is_super_admin?

      if [Building, Service, SatisfactionIndex, User, Administrator].include? resource_class
        @current_company.send(resource_class.to_s.downcase.pluralize)
      else
        scoped_resource_class
      end
    end

    def is_super_admin?
      current_administrator.id == 1
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
