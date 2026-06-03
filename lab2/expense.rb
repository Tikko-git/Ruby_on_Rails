class Expense
  attr_accessor :title, :categories, :payment_methods, :amount, :date, :notes, :status

  def initialize(title:, categories: [], payment_methods: [], amount: 0.0, date: nil, notes: "", status: "planned")
    @title = title
    @categories = categories
    @payment_methods = payment_methods
    @amount = amount.to_f
    @date = date || Time.now.strftime("%Y-%m-%d")
    @notes = notes
    @status = status
  end

  # Конвертація об'єкта у хеш для JSON
  def to_h
    {
      title: @title,
      categories: @categories,
      payment_methods: @payment_methods,
      amount: @amount,
      date: @date,
      notes: @notes,
      status: @status
    }
  end

  # Створення об'єкта з хешу
  def self.from_h(hash)
    new(
      title: hash[:title],
      categories: hash[:categories],
      payment_methods: hash[:payment_methods],
      amount: hash[:amount],
      date: hash[:date],
      notes: hash[:notes],
      status: hash[:status]
    )
  end
end