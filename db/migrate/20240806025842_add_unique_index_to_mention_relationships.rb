class AddUniqueIndexToMentionRelationships < ActiveRecord::Migration[7.0]
  def change
    add_index :mention_relationships, [:mentioning_id, :mentioned_id], unique: true
  end
end
