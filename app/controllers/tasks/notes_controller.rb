class Tasks::NotesController < ApplicationController
  before_action :set_task

  def create
    
    @note = @task.notes.new(note_params)
    @note.user = current_user
    @note.save

  end

  private

  # Debido a que los paramans están altamente protegidos,
  # debemos hacer lo siguiente:
  def note_params
    
    params.require(:note).permit(:body)

  end

  def set_task
    @task = Task.find(params[:task_id])
  end

end

