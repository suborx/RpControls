# -*- encoding : utf-8 -*-
require './main'
require 'sinatra/activerecord/rake'

task :environment do
    require File.expand_path(File.join(*%w[ config environment ]), File.dirname(__FILE__))
end

namespace :db do
  desc 'Load the seed data from db/seeds.rb'
  task :seed => :environment do
    User.delete_all
    Branch.delete_all
    Contact.delete_all
    Control.delete_all

    branches =
       [[ "Bratislavsko", "BA" ],
        [ "Dunajskostredsko", "DS"],
        [ "Galantsko-Šaliansko", "GA"],
        [ "Hlohovecko-Sereďsko", "HC"],
        [ "Komárňansko", "KM"],
        [ "Levicko", "LV"],
        [ "Malacko", "MA"],
        [ "Nitriansko-Zlatomoravecko", "NR"],
        [ "Novozámocko", "NZ"],
        [ "Pezinsko", "PK"],
        [ "Peišťansko-Novomestsko", "PN"],
        [ "Senecko", "SC"],
        [ "Senicko-Skalicko", "SE"],
        [ "Topoľčiansko-Partizánsko-Bánovecko", "TO"],
        [ "Trenčiansko-Dubnicko-Ilavsko", "TN"],
        [ "Trnavsko", "TT"],
        [ "Banskobystricko-Brezniansko", "BB"],
        [ "Kysucko-Čadčiansko-Kysuckonovonmestsko", "KY"],
        [ "Liptovskomikulášsko-Ružombersko", "LI"],
        [ "Lučensko-Veľkokrtíšsko-Poltársko", "LC"],
        [ "Martinsko-Turčianskoteplicko", "MT"],
        [ "Oravsko-D.Kubínsko-Námestovsko-Tvrdošínsko", "OR"],
        [ "Považskobystricko-Púchovsko", "PB"],
        [ "Prievidzko", "PD"],
        [ "Zvolensko-Detviansko-Krupinsko", "ZV"],
        [ "Žiarsko-Banskoštiavnicko-Žarnovicko", "ZH"],
        [ "Žilinsko-Bytčiansko", "ZA"],
        [ "Bardejovsko-Svidnícko-Stropkovsko", "BJ"],
        [ "Gemersko-Rim.Sobotsko-Rožňavsko-Revúcko", "GE"],
        [ "Humensko-Vranovsko-Sninsko-Medzilaborecko", "HU"],
        [ "Košicko", "KE"],
        [ "Košicko okolie", "KS"],
        [ "Michalovsko-Trebišovsko-Sobranecko", "MI"],
        [ "Popradsko-Kežmarsko-Staroľubovniansko", "PP"],
        [ "Prešovsko-Sabinovsko", "PO"],
        [ "Spišskonovomestsko-Levočsko-Gelnicko", "SN"]]

    branches.each do |b|
      branch = Branch.create(:name => b.first, :mark => b.last)

      user = User.new(
        :first_name => Faker::Name.first_name,
        :last_name => Faker::Name.last_name,
        :phone => Faker::PhoneNumber.phone_number,
        :branch_id => branch.id,
        :email => Faker::Internet.email,
        :password => 'heslo',
        :password_confirmation => 'heslo',
        :is_admin => false,
        :is_active => true
      )
      user.save

      10.times do |n|
        contact = Contact.create(
          :first_name => Faker::Name.first_name,
          :last_name => Faker::Name.last_name,
          :phone => Faker::PhoneNumber.phone_number,
          :branch_id => branch.id
        )

        10.times do |n|
          Control.create(
            :user_id => user.id,
            :contact_id => contact.id,
            :delivered => true_or_false,
            :succeed => true_or_false,
            :verified => true_or_false,
            :control_type => true_or_false ? 'Terenna' : 'Telefonická'
          )
        end
      end
    end

    admin = User.new(
      :first_name => 'Admin',
      :last_name => 'RpControl',
      :phone => '0944171017',
      :branch_id => Branch.first.id,
      :email => 'matoweb@gmail.com',
      :password => 'heslo',
      :password_confirmation => 'heslo',
      :is_admin => true,
      :is_active => true
    )
    admin.save

    controlor = User.new(
      :first_name => 'Martin',
      :last_name => 'Marochnic',
      :phone => '0944171017',
      :branch_id => Branch.first.id,
      :email => 'suborx@gmail.com',
      :password => 'heslo',
      :password_confirmation => 'heslo',
      :is_admin => false,
      :is_active => true
    )
    controlor.save
    puts User.first.full_name
  end
end

def true_or_false
  rand(2) == 1 ? true : false
end
