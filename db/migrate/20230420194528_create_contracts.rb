class CreateContracts < ActiveRecord::Migration[7.0]
  def change
    create_table :contracts, id: :uuid do |t|
      t.string :job_title, null: false
      t.string :contract_category, null: false
      t.string :term, null: false
      t.string :health_provider, null: false
      t.string :risk_type, null: false
      t.date :initial_date, null: false
      t.date :end_date, null: false
      t.references :worker, null: false, foreign_key: true, type: :uuid, unique: true

      t.timestamps
    end
  end
end
