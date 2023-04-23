class CreateWorkers < ActiveRecord::Migration[7.0]
  def change
    create_table :workers, id: :uuid do |t|
      t.string :name, null: false
      t.integer :id_number, limit: 10, null: false
      t.references :company, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
