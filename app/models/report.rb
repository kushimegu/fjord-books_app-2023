# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :active_relationships, class_name: "MentionRelationship", foreign_key: "mentioning_id", dependent: :destroy
  has_many :passive_relationships, class_name: "MentionRelationship", foreign_key: "mentioned_id", dependent: :destroy
  has_many :mentioning_reports, through: :active_relationships, source: :mentioned
  has_many :mentioned_reports, through: :passive_relationships, source: :mentioning

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def mention(id)
    active_relationships.create(mentioned_id: id)
  end

  def remove_mention(id)
    active_relationships.find_by(mentioned_id: id).destroy
  end

  def mentioning?(id)
    mentioning_reports.include?(id)
  end

  def create_mentions_from_urls(text)
    current_mentions = mentioning_reports.pluck(:id)
    urls = URI.extract(text, ['http', 'https']).uniq
    ids = urls.map { |url| url.match(/reports\/(\d+)/)[1] }.uniq
    ids.each do |id|
      mention(id) unless mentioning?(id) || id.to_i == self.id
    end
    (current_mentions - ids.map(&:to_i)).each do |id|
      remove_mention(id)
    end
  end
end
