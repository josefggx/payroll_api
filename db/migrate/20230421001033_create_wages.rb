class CreateWages < ActiveRecord::Migration[7.0]
  def change
    create_table :wages, id: :uuid do |t|
      t.decimal :base_salary, precision: 15, scale: 2, null: false
      t.boolean :transport_subsidy, null: false
      t.date :initial_date, null: false
      t.date :end_date, null: true
      t.references :contract, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
