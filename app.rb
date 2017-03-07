require 'rubygems'
require 'pony'
require 'sinatra'
require 'sinatra/reloader'

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
	


	output = File.open("./public/users.txt", "a")
	output.puts "Имя: #{@username}, Телефон: #{@telephone}, Время: #{@time}, Парикмахер: #{@worker}, Цвет: #{@color}"
	output.close
	erb "Вы записались как: Имя - #{@username}, Телефон - #{@telephone}, Время - #{@time}, Парикмахер - #{@worker}, Цвет окраски - #{@color} <br>Спасибо за внимание к нам!"
end

post '/login' do
	username  = params[:username]
	password = params[:password]

	if username == "admin" && password == "secret"

		 send_file "./public/users.txt"
		# redirect to('/users.txt')
	else
		@error = "Вы ошиблись"
		halt erb (:login_form)
	end
end

post '/contacts' do
text = params[:text]
if text == ''
		@error = 'Введите текст для отправки. '
		return erb :contacts
	end

Pony.mail({
      :to => 'xeonv@mail.ru',
      :from => 'xeonv@yandex.ru',
      :subject => 'BarberShop',
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
