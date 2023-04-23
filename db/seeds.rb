# frozen_string_literal: true

user1 = User.create(email: 'yoshi@gmail.com', password: '123456')
company1 = Company.create(name: 'Aleluyapp', nit: 127_345_678, user_id: user1.id)
Company.create(name: 'Nominapp', nit: 123_345_679, user_id: user1.id)
worker1 = Worker.create(name: 'Koopa Troopa', id_number: 1_234_098_632, company_id: company1.id)
contract1 = Contract.create(job_title: 'Secretario', contract_category: 'employee', term:	'indefinite',
                            risk_type: 'risk_1', health_provider: 'Sura', initial_date:	'2023-03-02', end_date: nil,
                            worker_id: worker1.id)
wage1 = Wage.create(base_salary:	1_300_000, transport_subsidy: true, initial_date:	'2023-03-02', end_date: nil,
                    contract_id: contract1.id)


user2 = User.create(email: 'wario@gmail.com', password: '123456')
company2 = Company.create(name: 'Empresa random', nit: 129_345_278, user_id: user2.id)
worker2 = Worker.create(name: 'Waluigi', id_number: 1_234_021_213, company_id: company2.id)
contract2 = Contract.create(job_title: 'Archivillano', contract_category: 'employee', term:	'indefinite',
                            risk_type: 'risk_1', health_provider: 'Sanitas', initial_date:	'2023-04-03', end_date: nil,
                            worker_id: worker2.id)
wage2 = Wage.create(base_salary:	2_600_000, transport_subsidy: false, initial_date:	'2023-04-03', end_date: nil,
                    contract_id: contract2.id)
