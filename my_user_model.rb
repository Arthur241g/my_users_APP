require 'sqlite3'

class User
    attr_accessor :id, :firstname, :lastname, :age, :email, :password

  def initialize(id, firstname, lastname, age, email, password)
    @id = id
    @firstname = firstname
    @lastname = lastname
    @age = age
    @email = email
    @password = password
  end


  def self.create(user_info)
    db = SQLite3::Database.new 'db.sql'
    
    db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY,
          firstname STRING,
          lastname STRING,
          age INTEGER,
          email STRING,
          password STRING
        );
      SQL

      db.execute 'INSERT INTO users (firstname, lastname, age, email, password) VALUES (?, ?, ?, ?, ?)', user_info[:firstname], user_info[:lastname], user_info[:age], user_info[:email], user_info[:password]
      user_id = db.last_insert_row_id
      user = db.execute('SELECT * FROM users WHERE id = ?', user_id).first
     
      db.close
     
      return nil if user.nil?
     
      User.new(user[0], user[1], user[2], user[3], user[4], user[5])
  end

  def self.find(user_id)
    db = SQLite3::Database.new 'db.sql'
    user = db.execute('SELECT * FROM users WHERE id = ?', user_id.to_i) 
    
    db.close
  
    return nil if user.empty?
  
    user_info = User.new(user[0][0], user[0][1], user[0][2], user[0][3], user[0][4], user[0][5])
    user_info.id = user[0][0] 
  
    return user_info
  end
  
  

  def self.all
    db = SQLite3::Database.new 'db.sql'
    users = db.execute'SELECT * FROM users'
    db.close

    return users
  end

  def self.update(user_id, attribute, value)
    db = SQLite3::Database.new 'db.sql'
    db.execute"UPDATE users SET #{attribute} = ? WHERE id = ?", value, user_id
    db.close
  end

  def self.destroy(user_id)
    db = SQLite3::Database.new 'db.sql'
    db.execute('DELETE FROM users WHERE id = ?', user_id)
    db.close
  end

  def self.status_register(password, email)
    db = SQLite3::Database.new 'db.sql'
    user = db.execute("SELECT * FROM users WHERE password = ? AND email = ?", password, email)
    db.close
    return user
      
  end
end
