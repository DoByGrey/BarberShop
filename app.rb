require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end	

def seed_db db, barbers

	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute'insert into Barbers (name) values (?)', [barber]
		end	
	end	

end	

def get_db
	db = SQLite3::Database.new 'BarberShop.db'
	db.results_as_hash = true
	return db
end	

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"name" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'

	db.execute 'CREATE TABLE IF NOT EXISTS
		"Contacts"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"email" TEXT, 
			"massage" TEXT
		)'	

	db.execute 'CREATE TABLE IF NOT EXISTS
	"Barbers"
	(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"name" TEXT
	)'	
	
	seed_db db,['Walter White', 'Jessie Pinkman', 'Gus Fring', 'Mike Ehrmantraut']

	db.close	
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

	# file = File.open './public/users.txt', 'a'
  # file.write "User: #{@user_name}, Phone: #{@phone}, Date and time: #{@datetime}, Master: #{@master}, color: #{@color}\n"
  # file.close

	db = get_db
	db.execute 'INSERT INTO 
		Users
		(
			Name, 
			Phone, 
			DateStamp, 
			Barber, 
			Color
		) 
		VALUES (?, ?, ?, ?, ?)', [@user_name, @phone, @datetime, @master, @color]

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

get '/showusers' do
	db = get_db
	
	@results = db.execute 'select * from Users order by id desc'
	db.close

	erb :showusers
end	

post '/showusers' do
		
end	