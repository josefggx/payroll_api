class Worker < ApplicationRecord
  validates :name, presence: true
  validates :id_number, presence: true, uniqueness: true

  belongs_to :company
  has_one :contract, dependent: :destroy
end
