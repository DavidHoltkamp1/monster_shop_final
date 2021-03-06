require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As an employee of a merchant' do
    before :each do
      @megans_mythicals = Merchant.create!(name: 'Mythical Creatures', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @merchant_user = @megans_mythicals.users.create!({
              name: "Merchant User",
              address: "123 Main St.",
              city: "Broomfield",
              state: "CO",
              zip: "80020",
              email: "merchant@example.com",
              password: "password",
              role: 1,
              merchant: @megans_mythicals
              })

      @ogre = @megans_mythicals.items.create!(name: 'Ogre',
              description: "I'm an Ogre!",
              price: 20,
              image: 'https://t4.rbxcdn.com/284aae33bbdfeef1fa35d8fc111a8d98',
              active: true,
              inventory: 25)

      @giant = @megans_mythicals.items.create!(name: 'Giant',
              description: "I'm a Giant!",
              price: 50,
              image: 'https://i.guim.co.uk/img/static/sys-images/Guardian/Pix/pictures/2012/12/7/1354883453249/Gollum-in-the-film-of-The-008.jpg?width=300&quality=85&auto=format&fit=max&s=860f7f0afb0f80f25eca8a2088316b38',
              active: true,
              inventory: 50)

      @hippo = @megans_mythicals.items.create!(name: 'Medusa',
              description: "I'm Snakey!",
              price: 50,
              image: 'https://cdna.artstation.com/p/assets/images/images/015/332/824/large/greg-laux-medusawip.jpg?1547958542',
              active: true,
              inventory: 75)

      @discount_1 = Discount.create({name: '10% off!',
              description: '10% off when ordering 10 or more',
              percentage_off: 10,
              minimum: 10,
              merchant_id: "#{@megans_mythicals.id}"})

      @discount_2 = Discount.create({name: '20% off!',
              description: '20% off when ordering 20 or more',
              percentage_off: 20,
              minimum: 20,
              merchant_id: "#{@megans_mythicals.id}"})

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    end

    it "I can click link to create a new discount" do
      visit '/merchant/discounts'

      click_link "Create New Discount"

      expect(current_path).to eq('/merchant/discounts/new')
    end

    it "I can create a new discount" do
      name = "25% off"
      description = "25% off when ordering 1000 items"
      percentage_off = 25
      minimum = 1000

      visit 'merchant/discounts/new'

      fill_in 'Name', with: name
      fill_in 'Description', with: description
      fill_in :percentage_off, with: percentage_off
      fill_in 'Minimum', with: minimum
      click_button 'Create Discount'

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content(name)
      expect(page).to have_content(description)
      expect(page).to have_content(percentage_off)
      expect(page).to have_content(minimum)
    end

    it "I cannot create a discount without all fields" do
      name = "25% off"
      description = "25% off when ordering 1000 items"
      percentage_off = 25
      minimum = 1000

      visit 'merchant/discounts/new'

      fill_in 'Name', with: name
      fill_in 'Description', with: description
      fill_in :percentage_off, with: ""
      fill_in 'Minimum', with: minimum
      click_button 'Create Discount'

      expect(current_path).to eq('/merchant/discounts/new')
      expect(page).to have_content("Percentage off can't be blank")
    end
  end
end
