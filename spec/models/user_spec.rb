require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validation' do

    it 'requires an email and password upon creation' do
      user = build(:user, email: nil, password: nil)

      expect(user.valid?).to equal(false)
      expect(user.errors.full_messages).to eq([
        "Password can't be blank",
        "Email can't be blank",
        "Email is invalid"
      ])
    end

    it 'requires that an email is unique' do
      create(:user)
      user = build(:user)
    
      expect(user.valid?).to equal(false)
      expect(user.errors.full_messages).to eq([
        "Email has already been taken"
      ])
    end

    it 'requires that an email is valid' do
      user1 = build(:user, email: "test.com")
      user2 = build(:user, email: "test@example")
      user3 = build(:user, email: "test")

      expect(user1.valid?).to equal(false)
      expect(user2.valid?).to equal(false)
      expect(user3.valid?).to equal(false)
      expect(user3.errors.full_messages).to eq([
        "Email is invalid"
      ])
    end
  end

  describe 'on save' do

    it 'hashes the password' do
      user = build(:user)
      user.save

      expect(user.password_digest).not_to equal(user.password)
    end
  end

  describe 'relationships' do

    it 'has one cart that is destroyed upon deletion of user' do
      user = create(:user)
      cart = user.create_cart(status: 'Active')

      expect(user.cart.id).not_to equal(nil) 

      user.destroy
      cart = Cart.find_by(id: cart.id)

      expect(cart).to eq(nil)
    end

    it 'has many order' do
      user = create(:user)
      user.orders.create

      expect(user.orders.first.id).not_to equal(nil) 
    end
  end
end
