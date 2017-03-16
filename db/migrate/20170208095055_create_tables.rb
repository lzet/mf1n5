class CreateTables < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :color, default: '#000000'
      t.belongs_to :user, index: true
    end
    add_index :tags, :name

    create_table :wallets do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.string :currency, limit: 5
      t.integer :value, limit: 8
      t.boolean :def, :boolean, default: false
    end

    create_table :items do |t|
      t.string :name
      t.integer :value, limit: 8
      t.belongs_to :wallet, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
     
    create_table :descriptions do |t|
      t.belongs_to :item, index: true
      t.belongs_to :tag, index: true
    end
  end
end
