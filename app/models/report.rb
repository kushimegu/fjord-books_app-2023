# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :active_relationships, class_name: 'MentionRelationship', foreign_key: 'mentioning_id', dependent: :destroy, inverse_of: :mentioning
  has_many :mentioning_reports, through: :active_relationships, source: :mentioned
  has_many :passive_relationships, class_name: 'MentionRelationship', foreign_key: 'mentioned_id', dependent: :destroy, inverse_of: :mentioned
  has_many :mentioned_reports, through: :passive_relationships, source: :mentioning

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def create_with_mentions(report_params)
    all_valid = false
    transaction do
      all_valid = save
      all_valid &= create_mentions_from_urls(report_params[:content])

      raise ActiveRecord::Rollback unless all_valid
    end
    all_valid
  end

  def update_with_mentions(report_params)
    all_valid = true
    transaction do
      all_valid = update(report_params)
      all_valid &= create_mentions_from_urls(report_params[:content])

      raise ActiveRecord::Rollback unless all_valid
    end
    all_valid
  end

  def create_mentions_from_urls(text)
    all_valid = true
    current_mention_ids = mentioning_reports.pluck(:id)
    urls = URI.extract(text, 'http').uniq
    ids = urls.map do |url|
      match_url = url.match(%r{\Ahttp://localhost:3000/reports/(\d+)\z})
      match_url ? match_url[1] : nil
    end.compact
    existing_mention_ids = mentioning_reports.where(id: ids).pluck(:id)
    ids.each do |id|
      all_valid &= mention(id) if !existing_mention_ids.include?(id) && id.to_i != self.id
    end
    (current_mention_ids - ids.map(&:to_i)).each do |id|
      all_valid &= remove_mention(id)
    end
    all_valid
  end

  def mention(id)
    active_relationships.create(mentioned_id: id)
  end

  def remove_mention(id)
    active_relationships.find_by(mentioned_id: id).destroy
  end
end
