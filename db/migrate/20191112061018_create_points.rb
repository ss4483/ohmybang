class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :points do |t|
      t.integer :pt

      t.date :exp_date
      t.integer :user_id
    end
  end
end
