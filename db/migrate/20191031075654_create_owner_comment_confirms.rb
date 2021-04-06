class CreateOwnerCommentConfirms < ActiveRecord::Migration[5.2]
  def change
    create_table :owner_comment_confirms do |t|
      t.text :memo
      t.string :status

      t.integer :owner_comment_id # user
      t.timestamps
    end
  end
end
