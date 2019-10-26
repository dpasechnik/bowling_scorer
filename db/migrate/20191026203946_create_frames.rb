class CreateFrames < ActiveRecord::Migration[6.0]
  def change
    create_table :frames do |t|
      t.belongs_to :game

      t.boolean :strike, default: false
      t.boolean :spare, default: false
      t.integer :bonus_roll_score
      t.integer :first_roll_score
      t.integer :second_roll_score
      t.integer :sequential_id
      t.integer :total_score, default: 0

      t.timestamps
    end
  end
end
