require_relative 'expense_manager'

class App
  def initialize
    @manager = ExpenseManager.new
    @yaml_file = 'expenses.yml'
    @json_file = 'expenses.json'
  end

  def run
    load_initial_data

    begin
      loop_menu
    ensure
      puts "\nАвтозбереження даних у YAML..."
      @manager.save_to_yaml(@yaml_file)
    end
  end

  private

  def load_initial_data
    if @manager.load_from_yaml(@yaml_file)
      puts "Дані завантажено з YAML."
    elsif @manager.load_from_json(@json_file)
      puts "Дані завантажено з JSON."
    else
      puts "Файлів не знайдено. Створено нову колекцію."
    end
  end

  def loop_menu
    loop do
      puts "\n--- МЕНЕДЖЕР ВИТРАТ ---"
      puts "1. Список усіх витрат"
      puts "2. Додати витрату"
      puts "3. Редагувати (Сума та Статус)"
      puts "4. Видалити за ID"
      puts "5. Пошук за назвою"
      puts "6. Загальна сума"
      puts "0. Вихід"
      print "Ваш вибір: "

      choice = gets.chomp
      case choice
      when "1" then show_list(@manager.collection)
      when "2" then input_expense
      when "3" then update_expense
      when "4" then remove_expense
      when "5" then search_expense
      when "6" then puts "Загальна сума: #{@manager.total_amount}"
      when "0" then break
      else puts "Невірний ввід."
      end
    end
  end

  def show_list(data)
    puts "\nID | Дата | Назва | Сума | Статус"
    puts "-" * 40
    data.each do |id, e|
      puts "#{id} | #{e.date} | #{e.title} | #{e.amount} | #{e.status}"
    end
  end

  def input_expense
    print "Назва: "; title = gets.chomp
    print "Сума: "; amount = gets.to_f
    print "Категорії (через кому): "; cats = gets.chomp.split(",").map(&:strip)
    print "Примітки: "; notes = gets.chomp
    print "Статус (planned, paid, cancelled): "; status = gets.chomp
    @manager.add_expense(title: title, amount: amount, categories: cats, notes: notes, status: status)
    puts "Додано успішно!"
  end

  def update_expense
    print "Введіть ID для редагування: "; id = gets.to_i
    if @manager.collection.key?(id)
      print "Нова сума: "; amt = gets.to_f
      print "Новий статус (planned/paid/cancelled): "; st = gets.chomp.strip

      data = {}
      data[:amount] = amt if amt > 0
      data[:status] = st unless st.empty?

      if @manager.edit_expense(id, data)
        puts "Дані оновлено!"
      end
    else
      puts "ID не знайдено!"
    end
  end

  def remove_expense
    print "ID для видалення: "; id = gets.to_i
    @manager.delete_expense(id) ? puts("Видалено.") : puts("Не знайдено.")
  end

  def search_expense
    print "Частина назви: "; q = gets.chomp
    show_list(@manager.find_by_title(q))
  end
end

App.new.run