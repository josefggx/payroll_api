class CreatePayrollAdditions < ActiveRecord::Migration[7.0]
  def change
    create_enum :addition_type, %w[deduction salary_income non_salary_income]

    create_table :payroll_additions, id: :uuid do |t|
      t.references :payroll, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.enum :addition_type, null: false, enum_type: 'addition_type'
      t.decimal :amount, precision: 15, scale: 2, null: false

      t.timestamps
    end
  end
end
