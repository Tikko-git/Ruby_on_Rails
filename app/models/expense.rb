class Expense < ApplicationRecord
  enum :status, { planned: 0, paid: 1, cancelled: 2 }

  # Scopes
  scope :paid, -> { where(status: :paid) }
  scope :planned, -> { where(status: :planned) }
  scope :big_expenses, -> { where('amount > ?', 2000) }
  scope :this_month, -> {
    where(date: Date.current.beginning_of_month..Date.current.end_of_month)
  }
end