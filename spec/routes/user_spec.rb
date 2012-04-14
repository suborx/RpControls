require "#{File.dirname(__FILE__)}/../spec_helper"

describe "site routes" do

  describe "get '/'" do
    it 'should respond with status 200' do
      get '/login'
      last_response.should be_ok
    end
  end

end
