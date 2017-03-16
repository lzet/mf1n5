class AddFormatOutDateToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :outdateformat, :string, default: '%Y.%m.%d'
  end
end
