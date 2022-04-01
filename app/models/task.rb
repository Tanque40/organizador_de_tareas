# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  due_date    :date
#  category_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Task < ApplicationRecord
  belongs_to :category
  belongs_to :owner, class_name: 'User'
  has_many :participating_users, class_name: 'Participant'
  has_many :participants, through: :participating_users, source: :user

  validates :participating_users, presence: true

  validates :name, :description, presence: true
  validates :name, uniqueness: { case_insensitive: false }
  validate :due_date_validity
  
  # Un callback que me ayuda a ejecutar codigo antes de que se guarde un archivo
  before_create :create_code

  # Para mandar el mail
  after_create :send_email
  
  accepts_nested_attributes_for :participating_users, allow_destroy: true
  
  def due_date_validity
  
    return if due_date.blank?
    return if due_date > Date.today

    errors.add :due_date, I18n.t('tasks.errors.invalid_due_date')

  end

  def create_code
    
    # Podemos verlo como un código de unicidad de la tarea
    # SecureRandom es una clase que nos da Rails para poder generar buenos aleatorios
    # Y con el .to_s(36) Lo convertimos en un string de base 36 para asegurarnos que no sea un numero muy grande
    self.code = "#{owner_id}#{Time.now.to_i.to_s(36)}#{SecureRandom.hex(8)}"

  end

  def send_email
    
    (participants + [owner]).each do |user|

      ParticipantMailer.with(user: user, task: self).new_task_email.deliver!
    
    end

  end

end
