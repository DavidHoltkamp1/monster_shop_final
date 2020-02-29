# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Merchant.destroy_all
Item.destroy_all
User.destroy_all

megans_mythicals = Merchant.create!(name: 'Mythical Creatures',
        address: '123 Main St',
        city: 'Denver',
        state: 'CO',
        zip: 80218)
brians_pets = Merchant.create!(name: 'Brians Pet Shop',
        address: '125 Main St',
        city: 'Denver',
        state: 'CO',
        zip: 80218)

megans_mythicals.items.create!(name: 'Ogre',
        description: "I'm an Ogre!",
        price: 20,
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw',
        active: true,
        inventory: 25)

megans_mythicals.items.create!(name: 'Giant',
        description: "I'm a Giant!",
        price: 50,
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw',
        active: true,
        inventory: 50)

megans_mythicals.items.create!(name: 'Medusa',
        description: "I'm Snakey!",
        price: 50,
        image: 'https://www.ancient-origins.net/sites/default/files/field/image/Medusa-Modern.jpg',
        active: true,
        inventory: 75)

brians_pets.items.create!(name: 'Hippo',
        description: "I'm a Hippo!",
        price: 50,
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw',
        active: true,
        inventory: 51)

brians_pets.items.create!(name: 'Wally the Walrus',
        description: "I'm a Walrus!",
        price: 100,
        image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Pacific_Walrus_-_Bull_%288247646168%29.jpg/1200px-Pacific_Walrus_-_Bull_%288247646168%29.jpg',
        active: true,
        inventory: 25)

brians_pets.items.create!(name: 'Ollie the Otter',
        description: "I'm an Otter!",
        price: 80,
        image: 'https://www.washingtonpost.com/wp-apps/imrs.php?src=https://arc-anglerfish-washpost-prod-washpost.s3.amazonaws.com/public/LEGGB4M5XY3I3CLXPJVSWOJ3LE.jpg&w=767',
        active: true,
        inventory: 100)

default_user = User.create({
        name: "Default User",
        address: "123 Main St.",
        city: "Broomfield",
        state: "CO",
        zip: "80020",
        email: "default@example.com",
        password: "password",
        role: 0
        })

merchant_user = User.create({
        name: "Merchant User",
        address: "123 Main St.",
        city: "Broomfield",
        state: "CO",
        zip: "80020",
        email: "merchant@example.com",
        password: "password",
        role: 1,
        merchant: megans_mythicals
        })

merchant_user_2 = User.create({
        name: "Merchant User 2",
        address: "123 Main St.",
        city: "Broomfield",
        state: "CO",
        zip: "80020",
        email: "merchant2@example.com",
        password: "password",
        role: 1,
        merchant: brians_pets
        })

admin_user = User.create({
        name: "Admin User",
        address: "123 Main St.",
        city: "Broomfield",
        state: "CO",
        zip: "80020",
        email: "admin@example.com",
        password: "password",
        role: 2
        })
