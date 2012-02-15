require 'sinatra/activerecord'

ActiveRecord::Base.configurations = {
  'local_db' => {
     'adapter' => 'mysql2',
     'encoding' => 'utf8',
     'host' => 'localhost',
     'username' => 'root',
     'password' => '',
     'database' => 'rpcontrol'
   },

  'remote_db' => {
    'adapter' => 'mysql2',
    'host' => '195.210.28.182',
    'username' => 'wordpress',
    'password' => 'AA@#zz235~#blazka',
    'database' => 'honeybee_production'
  }
 }
