class Worker < ApplicationRecord
  validates :name, presence: { code: '0301' }
  validates :id_number, presence: true, uniqueness: true
  # Tiene entre 6 y 10 digitos, solo números positivos y sí o sí tiene que ser un número

  belongs_to :company
  has_one :contract, validate: true, dependent: :destroy
  has_many :wages, through: :contract, validate: true
end
