require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Cart Show Page' do
  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 25 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 25 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 8 )

      @merchant_user = @megan.users.create!({
              name: "Merchant User",
              address: "123 Main St.",
              city: "Broomfield",
              state: "CO",
              zip: "80020",
              email: "merchant@example.com",
              password: "password",
              role: 1,
              merchant: @megan
              })

      @default_user = User.create({
              name: "Default User",
              address: "123 Main St.",
              city: "Broomfield",
              state: "CO",
              zip: "80020",
              email: "default@example.com",
              password: "password",
              role: 0
              })

      @discount_1 = Discount.create({name: 'Little Discount',
        description: 'Save when ordering more',
        percentage_off: 10,
        minimum: 5,
        maximum: 9,
        merchant_id: @megan.id})

      @discount_2 = Discount.create({name: '20% off!',
        description: '20% off when ordering 10 or more',
        percentage_off: 20,
        minimum: 10,
        maximum: 20,
        merchant_id: @megan.id})

      @discount_3 = Discount.create({name: 'Nice Discount!',
        description: 'Save 10% on 5 or more items!',
        percentage_off: 10,
        minimum: 5,
        maximum: 9,
        merchant_id: @brian.id
        })

      @discount_4 = Discount.create({name: 'Better Discount!',
        description: 'Save 20% on 10 or more items!',
        percentage_off: 20,
        minimum: 10,
        maximum: 20,
        merchant_id: @brian.id
        })

    end

    describe 'I can see my cart' do
      it "I can visit a cart show page to see items in my cart" do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        expect(page).to have_content("Total: #{number_to_currency((@ogre.price * 1) + (@hippo.price * 2))}")

        within "#item-#{@ogre.id}" do
          expect(page).to have_link(@ogre.name)
          expect(page).to have_content("Price: #{number_to_currency(@ogre.price)}")
          expect(page).to have_content("Quantity: 1")
          expect(page).to have_content("Subtotal: #{number_to_currency(@ogre.price * 1)}")
          expect(page).to have_content("Sold by: #{@megan.name}")
          expect(page).to have_css("img[src*='#{@ogre.image}']")
          expect(page).to have_link(@megan.name)
        end

        within "#item-#{@hippo.id}" do
          expect(page).to have_link(@hippo.name)
          expect(page).to have_content("Price: #{number_to_currency(@hippo.price)}")
          expect(page).to have_content("Quantity: 2")
          expect(page).to have_content("Subtotal: #{number_to_currency(@hippo.price * 2)}")
          expect(page).to have_content("Sold by: #{@brian.name}")
          expect(page).to have_css("img[src*='#{@hippo.image}']")
          expect(page).to have_link(@brian.name)
        end
      end

      it "I can visit an empty cart page" do
        visit '/cart'

        expect(page).to have_content('Your Cart is Empty!')
        expect(page).to_not have_button('Empty Cart')
      end
    end

    describe 'I can manipulate my cart' do
      it 'I can empty my cart' do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        click_button 'Empty Cart'

        expect(current_path).to eq('/cart')
        expect(page).to have_content('Your Cart is Empty!')
        expect(page).to have_content('Cart: 0')
        expect(page).to_not have_button('Empty Cart')
      end

      it 'I can remove one item from my cart' do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('Remove')
        end

        expect(current_path).to eq('/cart')
        expect(page).to_not have_content("#{@hippo.name}")
        expect(page).to have_content('Cart: 1')
        expect(page).to have_content("#{@ogre.name}")
      end

      it 'I can add quantity to an item in my cart' do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('More of This!')
        end

        expect(current_path).to eq('/cart')
        within "#item-#{@hippo.id}" do
          expect(page).to have_content('Quantity: 3')
        end
      end

      it 'I can not add more quantity than the items inventory' do

        8.times do
          visit item_path(@hippo)
          click_button 'Add to Cart'
        end

        visit '/cart'

        within "#item-#{@hippo.id}" do
          expect(page).to_not have_button('More of This!')
        end

        visit "/items/#{@hippo.id}"

        click_button 'Add to Cart'

        expect(page).to have_content("You have all the item's inventory in your cart already!")
      end

      it 'I can reduce the quantity of an item in my cart' do
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('Less of This!')
        end

        expect(current_path).to eq('/cart')
        within "#item-#{@hippo.id}" do
          expect(page).to have_content('Quantity: 2')
        end
      end

      it 'if I reduce the quantity to zero, the item is removed from my cart' do
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('Less of This!')
        end

        expect(current_path).to eq('/cart')
        expect(page).to_not have_content("#{@hippo.name}")
        expect(page).to have_content("Cart: 0")
      end

      it "I can see a bulk discount applied when proper inventory is added" do

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)

        2.times do
          visit item_path(@hippo)
          click_button 'Add to Cart'
        end

        5.times do
          visit item_path(@ogre)
          click_button 'Add to Cart'
        end

        10.times do
          visit item_path(@giant)
          click_button 'Add to Cart'
        end

        visit '/cart'

        within "#item-#{@ogre.id}" do
          expect(page).to have_content(@discount_1.description)
          expect(page).to_not have_content(@discount_2.description)
        end

        within "#item-#{@giant.id}" do
          expect(page).to have_content(@discount_2.description)
          expect(page).to_not have_content(@discount_1.description)
        end

        expect(page).to_not have_content(@discount_3.description)
        expect(page).to_not have_content(@discount_4.description)


        # expect(page).to have_content("Subtotal: $50.00")
        # expect(page).to have_content("Subtotal: $250.00")
        # expect(page).to have_content("Discounted Total: $25.00")
        # expect(page).to have_content("Grand Total: $225.00")
      end
    end
  end
end
