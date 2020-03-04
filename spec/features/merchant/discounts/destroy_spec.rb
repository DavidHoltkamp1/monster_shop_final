require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As an employee of a merchant' do
    before :each do
      Merchant.destroy_all
      Discount.destroy_all

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

      @discount_1 = Discount.create({name: 'Bulk Test',
        description: 'Save when ordering more',
        percentage_off: 10,
        minimum: 10,
        merchant_id: @megans_mythicals.id})

      @discount_2 = Discount.create({name: '20% off!',
        description: '20% off when ordering 20 or more',
        percentage_off: 20,
        minimum: 20,
        merchant_id: @megans_mythicals.id})

      end

    it "I can delete a discount" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)


      visit '/merchant/discounts'

      expect(Discount.all.count).to eq(2)

      within "#discounts-#{@discount_2.id}" do
        click_link "Delete Discount"
      end

      expect(Discount.all.count).to eq(1)

      visit '/merchant/discounts'

      # expect(current_path).to eq('/merchant/discounts')

      expect(page).to have_content("Bulk Test")

      # expect(page).not_to have_content("20% off when ordering 20 or more")
    end
  end
end
