class CreateContracts < ActiveRecord::Migration[7.0]
  def change
    create_enum :contract_terms, %w[fixed indefinite]
    create_enum :risk_type, %w[risk_1 risk_2 risk_3 risk_4 risk_5]

    create_table :contracts, id: :uuid do |t|
      t.string :job_title, null: false
      t.enum :term, null: false, enum_type: 'contract_terms'
      t.string :health_provider, null: false
      t.enum :risk_type, null: false, enum_type: 'risk_type'
      t.date :initial_date, null: false
      t.date :end_date, null: true
      t.references :worker, null: false, foreign_key: true, type: :uuid, unique: true

      t.timestamps
    end
  end
end