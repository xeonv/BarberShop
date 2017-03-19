require 'rubygems'
require 'pony'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	 db = SQLite3::Database.new 'BarberShop.sqlite'
	 db.results_as_hash = true
	 return db
end

def is_barber_exist? name
	get_db.execute('select * from Barbers where Name=?',[name]).length > 0 
end

 def seed_db barbers
 	barbers.each do |barber|
			if !is_barber_exist? barber
				get_db.execute 'insert into Barbers (Name) values (?)', [barber]
			end
	end
end

configure do

	get_db.execute 'CREATE TABLE IF NOT EXISTS 
			"Users" 
			(
				"Id" INTEGER PRIMARY KEY AUTOINCREMENT, 
				"Name" TEXT, 
				"Phone" TEXT, 
				"DateStamp" TEXT, 
				"Barber" TEXT, 
				"Color" TEXT
			)'

	get_db.execute 'CREATE TABLE IF NOT EXISTS 
			"Barbers" 
			(
				"Id" INTEGER PRIMARY KEY AUTOINCREMENT, 
				"Name" TEXT
			)'

		 seed_db ['Gus Fring', 'Jessie Pinkman', 'Walter White']

end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

get '/login' do
	erb :login_form
end

get '/showusers' do
	erb "Hello"
end

post '/visit' do
	@username  = params[:username]
	@telephone = params[:telephone]
	@time = params[:time]
	@worker = params[:worker]
	@color = params[:color]

	# if username == ''
	# 	@error = 'Введите имя. '
	# end

	# if telephone == ''
	# 	@error = @error + 'Введите телефон. '
	# end 

	# if time == ''
	# 	@error = @error + 'Введите время. '
	# end 

	# if @error != ''
	# 	return erb :visit
	# end

	hh = {:username =>'Введите имя. ', :telephone => 'Введите телефон. ', :time => 'Введите время. '}
	# длиный вариант проверки пустых полей
	# hh.each do |key, value|
	# 	if params[key] == ''
			
	# 		@error = hh [key]
	# 		return erb :visit
	# 	end	
	# end
	
	@error = hh.select {|k , v | params[k] == ""}.values.join (", ")

	if @error != ''
		return erb :visit
	end
	
	@error = nil

	# Запись данных в файл
	# output = File.open("./public/users.txt", "a")
	# output.puts "Имя: #{@username}, Телефон: #{@telephone}, Время: #{@time}, Парикмахер: #{@worker}, Цвет: #{@color}"
	# output.close
	# db = get_db
	get_db.execute 'insert into Users (Name, Phone, DateStamp, Barber, Color) values (?,?,?,?,?)', [@username, @telephone, @time, @worker, @color]


	erb "Вы записались как: Имя - #{@username}, Телефон - #{@telephone}, Время - #{@time}, Парикмахер - #{@worker}, Цвет окраски - #{@color} <br>Спасибо за внимание к нам!"
end

post '/login' do
	username  = params[:username]
	password = params[:password]

	if username == "1" && password == "1"
		 @db = get_db.execute 'select * from Users order by Id desc'
		get_users
		 erb :showusers

		 # send_file "./public/users.txt"
		# redirect to('/users.txt')
	else
		@error = "Вы ошиблись"
		halt erb (:login_form)
	end
end

post '/contacts' do
text = params[:text]
email = params[:email]
if text == ''
		@error = 'Введите текст для отправки. '
		return erb :contacts
	end

Pony.mail({
      :to => 'xeonv@mail.ru',
      :from => 'xeonv@yandex.ru',
      :subject => "BarberShop from #{email}",
      :body => params[:text],
      :via => :smtp,
      :via_options => {
        :address        => 'smtp.yandex.ru',
        :port           => '25',
        :enable_starttls_auto => true,
        :user_name      => 'xeonv',
        :password       => 'vragneproidet',
        :authentication => :plain # :plain, :login, :cram_md5, no auth by default
       	#:domain => "localhost"
      }
    })

  redirect '/'

end

def get_users
@table_users = ""
	get_db.execute 'select * from Users order by Id desc' do |row| 
			
		 @table_users += "<tr><td>#{row ['Name']}</td><td>#{row ['Phone']}</td><td>#{row ['DateStamp']}</td>
		 					<td>#{row ['Barber']}</td><td>#{row ['Color']}</td></tr>"
	end

end

 