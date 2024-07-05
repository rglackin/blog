class Article < ApplicationRecord
    include Visible
    has_many :comments, dependent: :destroy
    belongs_to :user
    validates :title, presence: true
    validates :body, presence: true, length: {minimum: 10}

    scope :search_by_title, -> (title) { where("title ILIKE ?", "%#{title}%") }
end
