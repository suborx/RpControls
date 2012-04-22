class AddVerifiedToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :verified, :boolean, :default => false
  end

  def self.down
    remove_column :contacts, :verified
  end
end
