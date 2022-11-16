class Article < ApplicationRecord
  has_paper_trail
  searchkick

  validates :title, :author, presence: true
end
