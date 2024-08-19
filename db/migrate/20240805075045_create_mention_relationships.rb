class CreateMentionRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :mention_relationships do |t|
      t.integer :mentioning_id, null: false
      t.integer :mentioned_id, null: false

      t.timestamps
    end

    add_index :mention_relationships, [:mentioning_id, :mentioned_id], unique: true
  end
end
