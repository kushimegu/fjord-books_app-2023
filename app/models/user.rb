# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :password, presence: true, on: :create
  validates :name, presence: true, on: :create
  validates :bio, length: { maximum: 200 }
end
