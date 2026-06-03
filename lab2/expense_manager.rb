require 'json'
require 'yaml'
require_relative 'expense'

class ExpenseManager
  attr_reader :collection

  def initialize
    @collection = {} # Ключ - Integer ID, значення - об'єкт Expense
  end

  def add_expense(expense_params)
    new_id = @collection.keys.any? ? @collection.keys.max + 1 : 1
    @collection[new_id] = Expense.new(**expense_params)
    new_id
  end

  def edit_expense(id, new_data)
    expense = @collection[id]
    if expense
      new_data.each do |key, value|
        setter = "#{key}="
        expense.send(setter, value) if expense.respond_to?(setter)
      end
      true
    else
      false
    end
  end

  def delete_expense(id)
    @collection.delete(id)
  end

  def find_by_title(query)
    @collection.select { |_, v| v.title.downcase.include?(query.downcase) }
  end

  def filter_by_status(status)
    @collection.select { |_, v| v.status == status }
  end

  def total_amount
    @collection.values.sum(&:amount).round(2)
  end

  def save_to_yaml(filename)
    File.write(filename, @collection.to_yaml)
  end

  def load_from_yaml(filename)
    if File.exist?(filename)
      raw_data = YAML.safe_load(File.read(filename), permitted_classes: [Expense, Symbol])
      @collection = raw_data || {}
      return true
    end
    false
  end

  def save_to_json(filename)
    # Конвертація у хеш для JSON серіалізації через to_h
    data_to_save = @collection.transform_values(&:to_h)
    File.write(filename, JSON.pretty_generate(data_to_save))
  end

  def load_from_json(filename)
    if File.exist?(filename)
      raw_json = JSON.parse(File.read(filename), symbolize_names: true)
      @collection = raw_json.each_with_object({}) do |(id, data), hash|
        hash[id.to_s.to_i] = Expense.from_h(data)
      end
      return true
    end
    false
  end
end