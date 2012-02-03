#help with https://github.com/plataformatec/devise
#for rails version >= 3.0.x
#create a new rails application 
--------------------------------------------------
$ rails new devise_demo -d mysql
--------------------------------------------------
# edit Gemfile.rb
---------------------------------------------------------------------------
gem 'mysql2','0.2.7'    #Only for rails 3.0.1 or but for rails 3.0.9  and for rails 3.1 no need to specify the version
gem 'rake','0.8.7'
gem 'devise','1.4.2'
---------------------------------------------------------------------------
$ bundle install
$ rake db:create
$ rails generate devise:install
$ rails generate devise [model-name]
$ rake db:migrate

#also add these code

#app/views/layout/appication.html.erb
-----------------------------------------------------------------------------------------------------------------
<html>
        <head>
                <title>DeviceExample</title>
                 <%= stylesheet_link_tag :all %>
                <%= javascript_include_tag :defaults %>
                <%= csrf_meta_tag %>
        </head>
        <body>
                <ul class="hmenu"></ul>
               <%- flash.each do |name, msg| -%>
                        <%= content_tag :div, msg, :id => "flash_#{name}" if msg.is_a?(String) %>
                <%- end -%>
                <div id="user_nav">
                        <% if user_signed_in? %>
                        Signed in as <%= current_user.email %>. Not you?
                                <%= link_to "Sign out", destroy_user_session_path, :method => :delete %>
                        <% else %>
                                 <%= link_to "Sign up", new_user_registration_path %> or <%= link_to "sign in", new_user_session_path %>
                        <% end %>
                </div>
                <%= yield %>
        </body>
</html>
-----------------------------------------------------------------------------------------------------------------
# create /public/stylesheets/application.css
---------------------------------------------------------
ul.hmenu {
  list-style: none;	
  margin: 0 0 2em;
  padding: 0;
}
ul.hmenu li {
  display: inline;  
}
#flash_notice, #flash_alert {
  padding: 5px 8px;
  margin: 10px 0;
}
#flash_notice {
  background-color: #CFC;
  border: solid 1px #6C6;
}
#flash_alert {
  background-color: #FCC;
  border: solid 1px #C66;
-----------------------------------------------------------------------------
#Now create a controller users
$ rails generate controller users index
# Make routes for user ---> add this in /config/routes.rb
        root :to => "users#index"
# boot your server
$ rails s
-----------------------------------------------------------------------------
---> http://localhost:3000/
#That's it 
-----------------------------------------------------------------------------
# What happens when we use  $ rails genreate devise:install ?
        when we use this, a generater is created for the devise and also create two file
        1 : create  config/initializers/devise.rb
        2 : create  config/locales/devise.en.yml
# What happens when we use  $ rails genreate devise [model-name] example $rails generate devise User?
        it create
-----------------------------------        
invoke  active_record
        create    app/models/user.rb
        invoke    test_unit
        create      test/unit/user_test.rb
        create      test/fixtures/users.yml
        create    db/migrate/20110809124144_devise_create_users.rb
        insert    app/models/user.rb
        route  devise_for :users
-----------------------------------
#app/models/user.rb
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
# What is  database_authentication ?
=>   " It convert the password into encripted form."
# What is  registerable ?
=>    " It is used to manage sign_in through register  and also edit and delete the signed in user"
# What is  recoverable ?
=>    "it is basically used for reset user password and send the rest instructions to the user"
#   What is  rememberable ?
=>   " manages generating and clearing a token for remembering the user from a saved cookie."
# What is  trackable ?
=>   "it traks the number of sign_in count, IP,timesamp of the user"
# What is  validatable ?
=>    "by defaults it validates email and password field but we can also define our validations."
 
# Now Whats about  db/migrate/20110809124144_devise_create_users.rb it contain some bydefault code like this
class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable
      t.timestamps
    end
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end
  def self.down
    drop_table :users
  end
end

1 => t.database_authenticatable :null => false
         it create fields
                i=> email
                ii => encrypted_password
2 => t.recoverable
          it create fields
                i => reset_password_token
                ii => reset_password_sent_at
3 => t.rememberable
                it create 
                    i => remember_created_at
4 => t.trackable
                it create fields
                        i => sign_in_count
                        ii => current_sign_in_at
                        iii => last_sign_in_at
                        iv => current_sign_in_ip
                        v => last_sign_in_ip 
