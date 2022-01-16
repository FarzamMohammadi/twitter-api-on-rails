class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.string :sender
      t.string :receiver
      t.text :message
      t.boolean :read

      t.timestamps
    end
  end
end
