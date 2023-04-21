# frozen_string_literal: true

user1 = User.create(email: 'yoshi@gmail.com', password: '123456')
company1 = Company.create(name: 'Aleluyapp', nit: '12345678', user_id: user1.id)
company2 = Company.create(name: 'Nominapp', nit: '12345679', user_id: user1.id)
Worker.create(name: 'Jairolas', id_number: '123545678', company_id: company1.id)

user2 = User.create(email: 'wario@gmail.com', password: '123456')
company3 = Company.create(name: 'Empresa random', nit: '12345278', user_id: user2.id)
Worker.create(name: 'Usuario random', id_number: '123542678', company_id: company3.id)
