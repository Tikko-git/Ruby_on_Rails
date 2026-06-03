require 'json'
require 'yaml'
require 'date'

# Додавання нової витрати
def add_expense(collection, title:, categories: [], payment_methods: [], amount: 0.0, date: Date.today.to_s, notes: "", status: "planned")
  new_id = collection.keys.any? ? collection.keys.max + 1 : 1

  collection[new_id] = {
    title: title,
    categories: categories,
    payment_methods: payment_methods,
    amount: amount.to_f,
    date: date,
    notes: notes,
    status: status
  }
  puts "Запис додано з ID: #{new_id}"
  new_id
end

# Редагування існуючої витрати
def edit_expense(collection, id, new_data)
  collection[id].merge!(new_data) if collection.key?(id)
end

# Видалення витрати
def delete_expense(collection, id)
  collection.delete(id)
end

# Пошук та фільтрація

# Пошук за частиною значення поля
def find_by_title(collection, query)
  collection.select { |_, v| v[:title].downcase.include?(query.downcase) }
end

# Фільтрація за категорією
def filter_by_category(collection, category)
  collection.select { |_, v| v[:categories].include?(category) }
end

# Фільтрація за статусом
def filter_by_status(collection, status)
  collection.select { |_, v| v[:status] == status }
end

# Розрахунок загальної суми
def total_amount(collection)
  total = collection.values.sum { |v| v[:amount] }
  puts "Загальна сума витрат: #{total.round(2)}"
  total
end

# Робота з файлами

# Збереження у JSON
def save_to_json(collection, filename)
  File.open(filename, "w") do |f|
    f.write(JSON.pretty_generate(collection))
  end
  puts "Дані збережено у файл #{filename} (JSON)."
end

# Завантаження з JSON
def load_from_json(filename)
  begin
    data = JSON.parse(File.read(filename), symbolize_names: true)
    data.transform_keys! { |k| k.to_s.to_i }
  rescue Errno::ENOENT
    puts "Файл #{filename} не знайдено. Створено порожню колекцію."
    {}
  rescue JSON::ParserError
    puts "Помилка при читанні JSON."
    {}
  end
end

# Збереження у YAML
def save_to_yaml(collection, filename)
  File.open(filename, "w") { |f| f.write(collection.to_yaml) }
  puts "Дані збережено у файл #{filename} (YAML)."
end

# Завантаження з YAML
def load_from_yaml(filename)
  begin
    YAML.safe_load(File.read(filename), permitted_classes: [Symbol, Date])
  rescue Errno::ENOENT
    puts "Файл #{filename} не знайдено. Створено порожню колекцію."
    {}
  end
end

# Приклад роботи
expenses = {}

add_expense(expenses, title: "Продукти", categories: ["Їжа"], amount: 450.5, status: "paid")
add_expense(expenses, title: "Оренда", categories: ["Побут"], amount: 12000, status: "planned")
id_medic = add_expense(expenses, title: "Аптека", categories: ["Здоров'я"], amount: 300, status: "paid")

# edit_expense(expenses, id_medic, amount: 350.0, notes: "Покупка вітамінів")
# delete_expense(expenses, 1)

# total_amount(expenses)

# save_to_json(expenses, "data.json")
save_to_yaml(expenses, "data.yml")


# result = find_by_title(expenses, "Ор")
# puts result

result = filter_by_status(expenses, "paid")
puts result

# total_amount(expenses)