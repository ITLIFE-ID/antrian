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
    before_action :set_administrate_thread

    def create
      resource = scoped_resource.new(resource_params)

      if resource.save
        redirect_to(
          after_resource_created_path(resource),
          notice: translate_with_resource("create.success")
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource)
        }, status: :unprocessable_entity
      end
    end

    def update
      requested_resource.restore if requested_resource.deleted?

      if requested_resource.update(resource_params)
        redirect_to(
          after_resource_updated_path(requested_resource),
          notice: translate_with_resource("update.success")
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, requested_resource)
        }, status: :unprocessable_entity
      end
    end

    def new
      add_breadcrumb I18n.t("new")
      super
    end

    def edit
      add_breadcrumb I18n.t("edit")
      super
    end

    def destroy
      if requested_resource.deleted? ? requested_resource.really_destroy! : requested_resource.destroy
        flash[:notice] = translate_with_resource("destroy.success")
      else
        flash[:error] = requested_resource.errors.full_messages.join("<br/>")
      end
      redirect_to after_resource_destroyed_path(requested_resource)
    end

    def set_current_company
      @current_company ||= current_administrator.company
    end

    def super_admin?
      current_administrator.id == 1
    end

    def set_administrate_thread
      Thread.current[:super_admin] = super_admin?
      Thread.current[:current_company] = @current_company
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
