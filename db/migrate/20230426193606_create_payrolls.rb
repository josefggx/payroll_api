class CreatePayrolls < ActiveRecord::Migration[7.0]
  def change
    create_table :payrolls, id: :uuid do |t|
      t.references :period, null: false, foreign_key: true, type: :uuid
      t.references :worker, null: false, foreign_key: true, type: :uuid
      t.decimal :base_salary, precision: 15, scale: 2, null: false
      t.decimal :transport_subsidy, precision: 15, scale: 2, null: false
      t.decimal :additional_salary_income, precision: 15, scale: 2, null: false
      t.decimal :non_salary_income, precision: 15, scale: 2, null: false
      t.decimal :worker_healthcare, precision: 15, scale: 2, null: false
      t.decimal :worker_pension, precision: 15, scale: 2, null: false
      t.decimal :solidarity_fund, precision: 15, scale: 2, null: false
      t.decimal :subsistence_account, precision: 15, scale: 2, null: false
      t.decimal :deductions, precision: 15, scale: 2, null: false
      t.decimal :company_healthcare, precision: 15, scale: 2, null: false
      t.decimal :company_pension, precision: 15, scale: 2, null: false
      t.decimal :arl, precision: 15, scale: 2, null: false
      t.decimal :compensation_fund, precision: 15, scale: 2, null: false
      t.decimal :icbf, precision: 15, scale: 2, null: false
      t.decimal :sena, precision: 15, scale: 2, null: false
      t.decimal :severance, precision: 15, scale: 2, null: false
      t.decimal :interest, precision: 15, scale: 2, null: false
      t.decimal :premium, precision: 15, scale: 2, null: false
      t.decimal :vacation, precision: 15, scale: 2, null: false
      t.decimal :worker_payment, precision: 15, scale: 2, null: false
      t.decimal :total_company_cost, precision: 15, scale: 2, null: false

      t.timestamps
    end
  end
end
