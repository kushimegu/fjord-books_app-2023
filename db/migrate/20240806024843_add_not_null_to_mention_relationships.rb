class Add NotNullToMentionRelationships < ActiveRecord::Migration[7.0]
  def change
    change_column_null :mention_relationships, :mentioning_id, false
    change_column_null :mention_relationships, :mentioned_id, false
  end
end
