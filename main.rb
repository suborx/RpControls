require 'sinatra/activerecord'

ActiveRecord::Base.configurations = {
  'local_db' => {
     'adapter' => 'mysql2',
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

class Branch < ActiveRecord::Base

  establish_connection 'local_db'

  validates_presence_of :name

end


class RpControl < Sinatra::Base

  get '/' do
    Branch.first.name
    haml :'branches/index'
  end

end
