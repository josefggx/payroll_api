class CreatePeriods < ActiveRecord::Migration[7.0]
  def change
    create_table :periods, id: :uuid do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
  end
end
