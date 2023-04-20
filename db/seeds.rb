# frozen_string_literal: true

user = User.create(email: 'yoshi@gmail.com', password: '123456')
Company.create(name: 'Aleluyapp', nit: '12345678', user_id: user.id)
