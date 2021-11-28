class CreateClientsTags < ActiveRecord::Migration[6.0]
  def change
    create_table :clients_tags do |t|
      t.integer :client_id
      t.integer :tag_id
    end
  end
end
