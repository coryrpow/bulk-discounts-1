require "rails_helper"

RSpec.describe "merchant dashboard" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @bulk_discount_1 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 20, merchant_id: @merchant1.id)
    @bulk_discount_2 = BulkDiscount.create!(percentage_discount: 15, quantity_threshold: 30, merchant_id: @merchant1.id)
    @bulk_discount_3 = BulkDiscount.create!(percentage_discount: 20, quantity_threshold: 40, merchant_id: @merchant1.id)

    visit "/merchants/#{@merchant1.id}/bulk_discounts"
  end

  it "each bulk discount listed includes a link to its show page" do
    expect(page).to have_content(@bulk_discount_1.percentage_discount)
    expect(page).to have_content(@bulk_discount_1.quantity_threshold)

    expect(page).to have_content(@bulk_discount_2.percentage_discount)
    expect(page).to have_content(@bulk_discount_2.quantity_threshold)

    expect(page).to have_content(@bulk_discount_3.percentage_discount)
    expect(page).to have_content(@bulk_discount_3.quantity_threshold)

    within("#bulk_show_link-#{@bulk_discount_1.id}") do
      expect(page).to have_link("#{@bulk_discount_1.id}")
      click_link("#{@bulk_discount_1.id}")
    end

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount_1.id}")
  end

  
  it "has a link to create a new discount I click this link which takes me to a new page where I see a form add new bulk discount
    When I fill in the form with valid data Then I am redirected back to the bulk discount index
    And I see my new bulk discount listed" do

    expect(page).to have_link("Create New Discount")

    click_link("Create New Discount")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/new")    
  end

  it "Takes you to a new page where there's a form to add a new bulk discount" do

    visit "/merchants/#{@merchant1.id}/bulk_discounts/new"


    expect(find("form")).to have_content("Add Percentage Discount")
    
  end

  it "When I fill in the form with valid data
  Then I am redirected back to the bulk discount index
  And I see my new bulk discount listed" do 
    visit "/merchants/#{@merchant1.id}/bulk_discounts/new"

    fill_in(:add_percentage_discount, with: 35)
    fill_in(:add_quantity_threshold, with: 50)
    

    click_button("Submit")
    
    @merchant1.reload

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")
    expect(page).to have_content("35")
    expect(page).to have_content("50")
  end

  it "shows a button next to each bulk discount to delete it" do
    within("#bulk_show_link-#{@bulk_discount_1.id}") do
      expect(page).to have_button("Delete Discount #{@bulk_discount_1.id}")
    end

  end

  it "when I click on this button I am redirected back to the bulk discounts index page
  And I no longer see the discount listed" do
    
    within("#bulk_show_link-#{@bulk_discount_1.id}") do
      click_button("Delete Discount #{@bulk_discount_1.id}")
    end

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")

    expect(page).to_not have_content("Percentage Discount:#{@bulk_discount_1.percentage_discount}")
    expect(page).to_not have_content("Quantity Threshold:#{@bulk_discount_1.quantity_threshold}")
  end
end

