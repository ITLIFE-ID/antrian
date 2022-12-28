module AdministrateHelper  
  def self.scoped_services(scope)
    is_super_admin(scope.first)? Service.order(name: :asc) : scope.second.services
  end

  def self.scoped_counters(scope)
    is_super_admin(scope.first)? Counter.order(name: :asc) : scope.second.counters
  end

  def self.scoped_buildings(scope)
    is_super_admin(scope.first)? Building.order(name: :asc) : scope.second.buildings
  end

  def self.scoped_satisfaction_indices(scope)
    is_super_admin(scope.first)? SatisfactionIndex.order(name: :asc) : scope.second.satisfaction_indices
  end

  def self.scoped_administrators(scope)
    is_super_admin(scope.first)? Administrator.order(name: :asc) : scope.second.administrators
  end

  def self.is_super_admin(user)
    user.id == 1 && user.is_a?(Administrator)
  end
end