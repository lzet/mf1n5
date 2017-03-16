class AddLangToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :lang, :string, default: 'en', limit: 4
  end
end
