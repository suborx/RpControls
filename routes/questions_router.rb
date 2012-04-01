# -*- encoding : utf-8 -*-

class RpControl < Sinatra::Base

  get '/questions' do
    @questions = Question.paginate(:page =>params[:page], :per_page => 18).includes([])
    haml :'questions/index'
  end

  get '/new/question' do
    @question = Question.new
    haml :'questions/new'
  end

  post '/questions' do
    if Question.create_questions(params[:question])
      flash.next[:success] = 'Pridanie otazky prebehlo úspešne.'
      redirect to '/questions'
    else
      flash.now[:error] = 'Pridanie otazky bolo neúspešné.'
      haml :'questions/new'
    end
  end

  get '/edit/questions/:id' do
    @question = Question.find(params[:id])
    haml :'questions/edit'
  end

  put '/questions/:id' do
    @question = Question.find(params[:id])
    if @question.update_question(params[:question])
      flash.next[:success] = 'Úprava otazky prebehla úspešne.'
      redirect to '/questions'
    else
      flash.now[:error] = 'Úprava otazky nebola úspešná.'
      haml :'questions/edit'
    end
  end

end
