class Expense < ApplicationRecord
  enum :status, { planned: 0, paid: 1, cancelled: 2 }

  validates :title, :amount, :category, presence: true
end
