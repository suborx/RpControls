# -*- encoding : utf-8 -*-
#
require "#{File.dirname(__FILE__)}/../spec_helper"

describe "Login" do

  it 'should login active admin' do
    create(:admin)
    visit '/login'
    fill_in 'user_email', :with => 'admin@admin.sk'
    fill_in 'user_password', :with => 'heslo123'
    click_button 'login'
    current_path.should == '/users'
    page.should have_content 'Kontrolóri'
    click_button 'logout'
  end

  it 'should login active kontrolor' do
    create(:user)
    visit '/login'
    fill_in 'user_email', :with => 'admin@admin.sk'
    fill_in 'user_password', :with => 'heslo123'
    click_button 'login'
    current_path.should == '/contacts'
    page.should have_content 'Respondenti'
    click_button 'logout'
  end

  it 'should not login inactive kontrolor' do
    create(:user, :is_active => false)
    visit '/login'
    fill_in 'user_email', :with => 'admin@admin.sk'
    fill_in 'user_password', :with => 'heslo123'
    click_button 'login'
    current_path.should == '/login'
  end

end
