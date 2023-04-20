class Company < ApplicationRecord
  validates :nit, presence: { code: '0201' }, uniqueness: { code: '0202' }
  validates :name, presence: { code: '0203' }, length: { in: 3..30, code: '0204' }

  belongs_to :user
end
