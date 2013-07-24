class Group < ActiveRecord::Base
  validates :code_name, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :users
end
