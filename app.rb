require 'rubygems'
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

	@user_name = params[:username]
	@phone 		 = params[:phone]
	@datetime  = params[:datetime]
	@master		 = params[:master]
	@color		 = params[:color]
	
	# хеш
	hh = { :user_name => 'Введите имя',
				 :phone => 'Введите телефон',
				 :datetime => 'Введите дату и время' }
	
	# для каждой пары ключ-значение 
	#hh.each do |key, value|
		# если параметр пуст
	#	if params[key] == ''
			# переменной error присвоить value из хеша hh
			# (а value из hh  это сообщение об ошибке)
			# т.е. переменной error присвоить сообщение об ошибке
	#		@error = hh[key]

			# вернуть представление visit
	#		return erb :visit
	#	end	
	#end	

	# вот такой метод записи
	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end	

	file = File.open './public/users.txt', 'a'
  file.write "User: #{@user_name}, Phone: #{@phone}, Date and time: #{@datetime}, Master: #{@master}, color: #{@color}\n"
  file.close

	erb "User: #{@user_name}, Phone: #{@phone}, Date and time: #{@datetime}, Master: #{@master}, color: #{@color}"
end

post '/contacts' do
	@user_email = params[:user_email]
	@message = params[:message]

	file = File.open './public/contacts.txt', 'a'
  file.write "User e-mail: #{@user_email}; Message: #{@message}\n"
  file.close
  
	erb "Сообщение отправлено!"
end	
