class CreatePayrolls < ActiveRecord::Migration[7.0]
  def change
    create_table :payrolls, id: :uuid do |t|
      t.references :period, null: false, foreign_key: true, type: :uuid
      t.references :worker, null: false, foreign_key: true, type: :uuid
      t.float :base_salary, null: false
      t.float :transport_subsidy, null: false
      t.float :additional_salary_income, null: false
      t.float :non_salary_income, null: false
      t.float :worker_healthcare, null: false
      t.float :worker_pension, null: false
      t.float :solidarity_fund, null: false
      t.float :subsistence_account, null: false
      t.float :deductions, null: false
      t.float :company_healthcare, null: false
      t.float :company_pension, null: false
      t.float :arl, null: false
      t.float :compensation_fund, null: false
      t.float :icbf, null: false
      t.float :sena, null: false
      t.float :severance, null: false
      t.float :interest, null: false
      t.float :premium, null: false
      t.float :vacation, null: false
      t.float :worker_payment, null: false
      t.float :total_company_cost, null: false

      t.timestamps
    end
  end
end
