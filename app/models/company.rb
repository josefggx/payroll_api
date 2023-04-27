class Company < ApplicationRecord
  belongs_to :user
  has_many :workers, dependent: :destroy
  has_many :contracts, through: :workers
  has_many :wages, through: :contracts
  has_many :periods, dependent: :destroy
  has_many :payrolls, through: :periods

  validates :nit, presence: { code: '0201' },
                  uniqueness: { code: '0202' },
                  numericality: { greater_than: 0, code: '0203', if: -> { nit.present? } },
                  length: { is: 9, code: '0204', if: -> { nit.present? } }

  validates :name, presence: { code: '0211' }, length: { in: 3..30, code: '0212' }
end
