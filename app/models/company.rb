class Company < ApplicationRecord
  validates :nit, presence: { code: '0201' },
                  uniqueness: { code: '0202' },
                  numericality: { greater_than: 0, code: '0203' },
                  length: { is: 9, code: '0204' }

  validates :name, presence: { code: '0211' }, length: { in: 3..30, code: '0212' }

  belongs_to :user
  has_many :workers
  has_many :contracts, through: :workers
  has_many :wages, through: :contracts
end
