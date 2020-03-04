require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As an employee of a merchant' do
    before :each do
      @megans_mythicals = Merchant.create!(name: 'Mythical Creatures', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
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
      @hippo = @merchant_2.items.create!(name: 'Medusa',
              description: "I'm Snakey!",
              price: 50,
              image: 'https://cdna.artstation.com/p/assets/images/images/015/332/824/large/greg-laux-medusawip.jpg?1547958542',
              active: true,
              inventory: 75)

      @discount_1 = Discount.create(name: '10% off!',
              description: '10% off when ordering 10 or more',
              percentage_off: 10,
              minimum: 10,
              merchant_id: @megans_mythicals)

      @discount_2 = Discount.create(name: '20% off!',
              description: '20% off when ordering 20 or more',
              percentage_off: 20,
              minimum: 20,
              merchant_id: @megans_mythicals)

      @order_1 = @merchant_user.orders.create!(status: "pending")
      @order_2 = @merchant_user.orders.create!(status: "pending")
      @order_3 = @merchant_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it 'I can see my merchants information on the merchant dashboard' do
      visit '/merchant'

      expect(page).to have_link(@megans_mythicals.name)
      expect(page).to have_content(@megans_mythicals.address)
      expect(page).to have_content("#{@megans_mythicals.city} #{@megans_mythicals.state} #{@megans_mythicals.zip}")
    end

    it 'I do not have a link to edit the merchant information' do
      visit '/merchant'

      expect(page).to_not have_link('Edit')
    end

    it 'I see a list of pending orders containing my items' do
      visit '/merchant'

      within '.orders' do
        expect(page).to_not have_css("#order-#{@order_1.id}")

        within "#order-#{@order_2.id}" do
          expect(page).to have_link(@order_2.id)
          expect(page).to have_content("Potential Revenue: #{@order_2.merchant_subtotal(@megans_mythicals.id)}")
          expect(page).to have_content("Quantity of Items: #{@order_2.merchant_quantity(@megans_mythicals.id)}")
          expect(page).to have_content("Created: #{@order_2.created_at}")
        end

        within "#order-#{@order_3.id}" do
          expect(page).to have_link(@order_3.id)
          expect(page).to have_content("Potential Revenue: #{@order_3.merchant_subtotal(@megans_mythicals.id)}")
          expect(page).to have_content("Quantity of Items: #{@order_3.merchant_quantity(@megans_mythicals.id)}")
          expect(page).to have_content("Created: #{@order_3.created_at}")
        end
      end
    end

    it 'I can link to an order show page' do
      visit '/merchant'

      click_link @order_2.id

      expect(current_path).to eq("/merchant/orders/#{@order_2.id}")
    end

    it "I can see a link to discount index page" do
      visit '/merchant'

      click_link "All Discounts"

      expect(current_path).to eq("/merchant/discounts")
    end
  end
end
