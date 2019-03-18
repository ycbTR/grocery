#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Account.create(name: 'Yönetici', card: 1234, admin: true, credit_limit: 100)

Product.create(name: 'Çay', price: 1)
Product.create(name: 'Büyük Çay', price: 2)
Product.create(name: 'Su', price: 1)
Product.create(name: 'Nescafe', price: 2)
Product.create(name: 'Türk Kahvesi', price: 2)
Product.create(name: 'Çokonat', price: 1.5)
Product.create(name: 'Gofret', price: 1)
Product.create(name: 'Metro', price: 1.5)
Product.create(name: 'Albeni', price: 1.5)
Product.create(name: 'Kek', price: 1)
Product.create(name: 'Çubuk Kraker', price: 1.5)
Product.create(name: 'Efes Malt', price: 12)
Product.create(name: 'Efes', price: 12)
Product.create(name: 'Bomonti', price: 13)
Product.create(name: 'Miller', price: 14)
Product.create(name: 'Corona', price: 15)
Product.create(name: 'Yemek Menü', price: 15)
Product.create(name: 'Bitki çayı', price: 2)