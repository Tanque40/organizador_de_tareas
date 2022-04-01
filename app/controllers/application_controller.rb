class ApplicationController < ActionController::Base
  # Callbacks
  # Le digo que antes de que se ejecute una tarea
  # Hay callbacks para después de las acciones 
  before_action :set_locale

  before_action :authenticate_user!


  
  #Cuando con cancan me manda un error de mostrar
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path
  end

  def set_locale
    I18n.locale = 'es'
  end

end
