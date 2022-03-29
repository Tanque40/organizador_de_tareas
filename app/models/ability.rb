# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    #can :manage # Accedo a todo
    #can :manage, Task # Accedo a task

    # le digo que el usuario puede manejar la tarea que uno mismo haya creado
    can :manage, Task, owner_id: user.id
  end
end
