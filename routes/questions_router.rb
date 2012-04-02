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

  get '/questions_for_control/:control_id/:user_id/:week_date' do
    @control_id = params[:control_id]
    user = User.find(params[:user_id])
    @questions = questions_for_branch_and_week(user.branch_id, params[:week_date])
    haml :'questions/questions_for_control', :layout => false
  end

  get '/questions_for_questions/:branch_id/:week_date' do
    @branch = Branch.find(params[:branch_id])
    @week_date = Date.parse params[:week_date]
    @questions = questions_for_branch_and_week(params[:branch_id],params[:week_date])
    haml :'questions/questions_for_questions', :layout => false
  end

  private

  def questions_for_branch_and_week(branch_id,week_date)
    @week = Week.first(:conditions => {:branch_id => branch_id, :week_date => week_date})
    @week ? @week.questions : []
  end
end
