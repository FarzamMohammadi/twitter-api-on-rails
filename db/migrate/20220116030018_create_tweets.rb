class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.string :username
      t.string :description
      t.string :like
      t.string :retweet

      t.timestamps
    end
  end
end
