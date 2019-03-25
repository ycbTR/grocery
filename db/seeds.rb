#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Account.create(name: 'Yönetici#1', card: 1234, admin: true, credit_limit: 100)
Account.create(name: 'Yönetici#2', card: 922778148556, admin: true, credit_limit: 100)
Account.create(name: 'Yönetici#3', card: 170679784199, admin: true, credit_limit: 100)

p = Product.create(name: 'Çay', price: 1)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/cay.png"), filename: 'cay.png')

p = Product.create(name: 'Büyük Çay', price: 2)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/buyuk-cay.jpeg"), filename: 'buyuk-cay.jpeg')

p = Product.create(name: 'Su', price: 1)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/su.png"), filename: 'su.png')

p = Product.create(name: 'Nescafe', price: 2)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/nescafe.png"), filename: 'nescafe.png')

p = Product.create(name: 'Bira', price: 12)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/bira.jpg"), filename: 'bira.jpg')

p = Product.create(name: 'Türk Kahvesi', price: 2)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/tkahve.jpg"), filename: 'tkahve.jpg')

p = Product.create(name: 'Çokonat', price: 1.5)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/cokonat.jpg"), filename: 'cokonat.jpg')

p = Product.create(name: 'Gofret', price: 1)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/gofret.jpg"), filename: 'gofret.jpg')

p = Product.create(name: 'Metro', price: 1.5)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/metr.jpg"), filename: 'metr.jpg')

p = Product.create(name: 'Albeni', price: 1.5)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/albeni.jpg"), filename: 'albeni.jpg')

p = Product.create(name: 'Cocostar', price: 1.5)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/cocostar.png"), filename: 'cocostar.png')

p = Product.create(name: 'Kek', price: 1)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/topkek.png"), filename: 'topkek.png')

p = Product.create(name: 'Çubuk Kraker', price: 1.5)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/cubuk.jpg"), filename: 'cubuk.jpg')

p = Product.create(name: 'Yemek Menü', price: 15)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/yemek.jpg"), filename: 'yemek.jpg')

p = Product.create(name: 'Bitki çayı', price: 2)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/bitkicayi.jpg"), filename: 'bitkicayi.jpg')

p = Product.create(name: 'Efes Malt', price: 12)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/efesmalt.jpg"), filename: 'efesmalt.jpg')

p = Product.create(name: 'Efes', price: 12)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/bira.jpg"), filename: 'bira.jpg')

p = Product.create(name: 'Bomonti', price: 13)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/bomonti.jpeg"), filename: 'bomonti.jpeg')

p = Product.create(name: 'Miller', price: 14)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/miller.jpg"), filename: 'miller.jpg')

p = Product.create(name: 'Corona', price: 15)
p.image.attach(io: File.open("#{Rails.root}/app/assets/images/corona.jpeg"), filename: 'corona.jpeg')
