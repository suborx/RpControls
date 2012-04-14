require "#{File.dirname(__FILE__)}/../spec_helper"

describe User do

  describe "Validations" do

    it '#validate_presence_of :email' do
      u = build(:user, :email => nil)
      u.should_not be_valid
      u.errors[:email].should  have(1).item
    end

    it '#validate_presence_of :first_name' do
      u = build(:user, :first_name => nil)
      u.should_not be_valid
      u.errors[:first_name].should  have(1).item
    end

    it '#validate_presence_of :last_name' do
      u = build(:user, :last_name => nil)
      u.should_not be_valid
      u.errors[:last_name].should  have(1).item
    end

    it '#validate_presence_of :phone' do
      u = build(:user, :phone => nil)
      u.should_not be_valid
      u.errors[:phone].should  have(1).item
    end

    it '#validate_presence_of :branch' do
      u = build(:user, :branch => nil)
      u.should_not be_valid
      u.errors[:branch_id].should  have(1).item
    end

    it '#validate_presence_of :password' do
      u = build(:user, :password => nil)
      u.should_not be_valid
      u.errors[:password].should  have(2).item
    end

    it '#validate_confirmation_of :password' do
      u = build(:user, :password => 'heslo')
      u.should_not be_valid
      u.errors[:password].should  have(1).item
    end

    it '#validate_uniqueness_of :email' do
      create(:user, :email => 'admin@admin.sk')
      u = build(:user, :email => 'admin@admin.sk')
      u.should_not be_valid
      u.errors[:email].should  have(1).item
    end

  end

  describe "UserActivations" do

    it "#activate!" do
      u = create(:user, :is_active => false)
      u.activate!
      u.is_active.should be
    end


    it "#deactivate!" do
      u = create(:user, :is_active => true)
      u.deactivate!
      u.is_active.should_not be
    end

  end

  describe 'Authentification' do

      before(:each) do
      end

      it "#encrypt_password" do
        user = Factory.build(:user, :password => 'Heslo', :password_confirmation => 'Heslo')
        user.password_salt.should be_blank
        user.password_hash.should be_blank
        user.encrypt_password
        user.password_hash.should == BCrypt::Engine.hash_secret('Heslo', user.password_salt)
      end

      it ".authenticate active user" do
        u = create(:user, :email => 'admin@admin.sk', :password => 'heslo', :password_confirmation => 'heslo', :is_active => true)
        current_user = User.authenticate('admin@admin.sk','heslo')
        current_user.should === u
      end

      it ".authenticate inactive  user" do
        u = create(:user, :email => 'admin@admin.sk', :password => 'heslo', :password_confirmation => 'heslo', :is_active => false)
        current_user = User.authenticate('admin@admin.sk','heslo')
        current_user.should_not be
      end

  end

  it '#full_name' do
    u = build(:user, :first_name => 'Janko', :last_name => 'Hrasko')
    u.full_name.should == 'Hrasko Janko'
  end

end
