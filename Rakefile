# -*- encoding : utf-8 -*-
require './main'
require 'sinatra/activerecord/rake'
require 'rubygems'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'fileutils'
require 'logger'

task :default do
  puts "Available tasks:"
  Rake.application.options.show_tasks = true
  Rake.application.options.full_description = false
  Rake.application.options.show_task_pattern = //
  Rake.application.display_tasks_and_comments
end

task :environment do
  require "#{File.dirname(__FILE__)}/main.rb"
end

begin
  desc 'Run all tests'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = [ '--backtrace', '--colour', '-fd']
  end
rescue LoadError
end

namespace :spec do
  begin
    desc 'Run all model tests'
    RSpec::Core::RakeTask.new(:models) do |t|
      t.pattern = 'spec/models/**/*_spec.rb'
      t.rspec_opts = [ '--backtrace', '--colour', '-fd']
    end
  rescue LoadError
  end

  begin
    desc 'Run all route tests'
    RSpec::Core::RakeTask.new(:routes) do |t|
      t.pattern = 'spec/routes/**/*_spec.rb'
      t.rspec_opts = [ '--backtrace', '--colour', '-fd']
    end
  rescue LoadError
  end
end

namespace :db do

  desc 'Run database migrations'
  task :migrate => :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate('db/migrate')
  end

  desc 'Run database migrations for test database'
  task :migrate => :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate('db/migrate')
  end

  desc 'Rollback last migration'
  task :rollback => %w(env) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.rollback('db/migrate')
  end

  desc 'Reset the database'
  task :reset => %w(env) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.down('db/migrate')
    ActiveRecord::Migrator.migrate('db/migrate')
  end

  desc 'Output the schema to db/schema.rb'
  task :schema => %w(env) do
    File.open('db/schema.rb', 'w') do |f|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, f)
    end
  end

  desc 'Load the seed data for production'
  task :production_seed => [:delete_all, :load_branches, :basic_accesses ] do
  end

  desc 'Load the seed data for development'
  task :development_seed => [:delete_all, :load_branches, :basic_accesses, :generate_fake_data] do
  end

  desc 'Create admin user and controlor user'
  task :basic_accesses => :environment do
    admin = create_user(Branch.first, {:first_name => 'Admin', :last_name => 'Admín', :email => 'admin@admin.sk', :is_admin => true })
    puts "#{admin.full_name} pridaný"
    admin = create_user(Branch.first, {:first_name => 'Martin', :last_name => 'Marochnič', :email => 'seller@seller.sk'})
    puts "#{admin.full_name} pridaný"
  end

  desc 'Generate fake users, controlors and controls'
  task :generate_fake_data => :environment do
    Branch.all.each do |b|
      user = create_user(b)
      10.times do |n|
        contact = create_contact(b)
        10.times{ |n| create_control(user,contact)}
      end
    end
  end

  desc 'Load the branches'
  task :load_branches => :environment do
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
    branches.each{ |b|  branch = Branch.create(:name => b.first, :mark => b.last)}
  end

  desc 'Delete all data'
  task :delete_all => :environment do
    User.delete_all
    Contact.delete_all
    Control.delete_all
    Branch.delete_all
  end

  desc 'Delete all controls'
  task :delete_all_controls => :environment do
    Control.delete_all
  end
end

def true_or_false
  rand(2) == 1 ? true : false
end

def create_user(branch, options={})
  attrs = {
    :first_name => Faker::Name.first_name,
    :last_name => Faker::Name.last_name,
    :phone => Faker::PhoneNumber.phone_number,
    :branch_id => branch.id,
    :email => Faker::Internet.email,
    :password => 'heslo',
    :password_confirmation => 'heslo',
    :is_admin => false,
    :is_active => true}.merge!(options)
  u = User.create(attrs)
end

def create_contact(branch)
  contact = Contact.create(
    :first_name => Faker::Name.first_name,
    :last_name => Faker::Name.last_name,
    :phone => Faker::PhoneNumber.phone_number,
    :branch_id => branch.id,
    :city => Faker::Address.city,
    :street => Faker::Address.street_name,
    :number => rand(100)
  )
end

def create_control(user,contact)
  10.times do |n|
    Control.create(
      :user_id => user.id,
      :contact_id => contact.id,
      :regulary_delivered => true_or_false,
      :succeed => true_or_false,
      :verified => true_or_false,
      :control_type => true_or_false ? 'Terénna' : 'Telefonická'
    )
  end
end
