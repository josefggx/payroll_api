class Contract < ApplicationRecord
  validates :job_title, presence: true
  validates :contract_category, presence: true
  validates :term, presence: true
  validates :health_provider, presence: true
  validates :risk_type, presence: true
  validates :initial_date, presence: true
  validates :worker, presence: true
  validates_associated :wages

  belongs_to :worker
  has_many :wages, dependent: :destroy
end
