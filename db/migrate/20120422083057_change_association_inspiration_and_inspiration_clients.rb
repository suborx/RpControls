class ChangeAssociationInspirationAndInspirationClients < ActiveRecord::Migration
  def self.up
    remove_column :inspiration_clients, :inspiration_id
    add_column :inspirations, :inspiration_client_id, :integer
    add_index :inspirations, :inspiration_client_id
  end

  def self.down
    add_column :inspiration_clients, :inspiration_id
    remove_column :inspirations, :inspiration_client_id
    add_index :inspiration_clients, :ispiration_id
    remove_index :inspirations, :ispiration_client_id
  end
end
