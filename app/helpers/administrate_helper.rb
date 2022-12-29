module AdministrateHelper
  # scope.first = is_super_admin, scope.second = @current_company
  def self.scoped_companies(scope)
    scope.first ? Company.order(name: :asc) : Company.where(id: scope.second.id)
  end

  def self.scoped_services(scope)
    scope.first ? Service.order(name: :asc) : scope.second.services
  end

  def self.scoped_counters(scope)
    scope.first ? Counter.order(name: :asc) : scope.second.counters
  end

  def self.scoped_buildings(scope)
    scope.first ? Building.order(name: :asc) : scope.second.buildings
  end

  def self.scoped_satisfaction_indices(scope)
    scope.first ? SatisfactionIndex.order(name: :asc) : scope.second.satisfaction_indices
  end

  def self.scoped_administrators(scope)
    scope.first ? Administrator.order(name: :asc) : scope.second.administrators
  end

  def self.scoped_users(scope)
    scope.first ? User.order(name: :asc) : scope.second.users
  end

  def self.scoped_client_displays(scope)
    scope.first ? ClientDisplay.order(name: :asc) : scope.second.client_displays
  end

  def self.scoped_service_types(scope)
    scope.first ? ClientDisplay.order(name: :asc) : scope.second.service_types
  end

  def self.polymorph_schedule(scope)
    if scope.first
      [Company, Service]
    else
      [Company.where(id: scope.second.id), Service.where(company: scope.second)]
    end
  end

  def self.polymorph_shared_client_display(scope)
    if scope.first
      [Service, Counter]
    else
      [Service.where(company: scope.second), Counter.where(service: scope.second.services)]
    end
  end
end
