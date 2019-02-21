class SqlController < Sinatra::Base 
	helpers Sinatra::Cookies

	set :root, File.join(File.dirname(__FILE__), '..')

	set :views, Proc.new { File.join(root, "views") }

	enable :sessions
	use Rack::Session::Cookie, :key => 'my_app_key', :path => '/', :expire_after => 2000000, :secret => 'secret_stuff'

	#index
	get '/' do
		erb :'pages/index'
	end

	#info
	get '/info' do
		if session[:userid] == nil
			redirect "student/login"
		end
		erb :'pages/info_page'
	end

	#student route
	get '/student/login' do
		if session[:userid] == nil
			erb :'pages/student_login'
		else
			redirect "/question/1"
		end
		erb :'pages/student_login'
	end

	delete "/" do
		session[:userid] = nil
		redirect '/student/login'
  end

	get '/question/1' do
		@user = User.new
		@user.userid = session[:userid]
		@user.get_completed
		if @user.get_completed[0] == "t"
			redirect '/student/score'
		end
		if session[:userid] == nil
			redirect "student/login"
		end
		@userid = session[:userid]
		@posts = Question.all
		@answers = Answer.new
		@answers.studenttestid = session[:testid]
		@studentanswers = @answers.all
		erb :'pages/question_one_page'
	end

	post '/question/1' do
		answer = Test.new
		# bind the values
		answer.studentanswer = params[:studentanswer]
		answer.questionid = params[:id].to_i
		answer.studenttestid = session[:testid]
		# save the post
		answer.save_answers
		redirect '/question/1'
	end

	post '/student/login' do 
		@user = User.new
		@course = Course.new
		@test = Test.new
		@email = params[:email]
		@password = params[:password]
		@api = InternalManagementSystemAPI.new
		@api.retrieve_token(@email, @password)
		@course.courseid = @api.retrieve_cohort_id
		@course.coursename = @api.retrieve_cohort_name
		@user.userid = @api.retrieve_user_id
		@user.cohortid = @api.retrieve_cohort_id
		@user.rolename = @api.retrieve_role_name
		@user.firstname = @api.retrieve_first_name
		@user.lastname = @api.retrieve_last_name
		@test.studentid = @api.retrieve_user_id
	  if @api.retrieve_success == true && @api.retrieve_role_name == "Trainee"
			session[:userid] = "#{@api.retrieve_user_id}"
			@course.save
			@user.save
			@test.add_test
			session[:testid] = @test.find_test[0]['studenttestid'].to_i
			if @user.get_completed[0] == "t"
				redirect '/student/score'
			end
			redirect "question/1"
		else
			redirect "student/login"
		end

	end

	get '/question/2' do
		@user = User.new
		@user.userid = session[:userid]
		@user.get_completed
		if @user.get_completed[0] == "t"
			redirect '/student/score'
		end
		if session[:userid] == nil
			redirect "student/login"
		end
		erb :'pages/question_two_page'
	end

	get '/question/3' do
		@user = User.new
		@user.userid = session[:userid]
		@user.get_completed
		if @user.get_completed[0] == "t"
			redirect '/student/score'
		end
		erb :'pages/question_three_page'
	end

	get '/student/review' do
		@user = User.new
		@user.userid = session[:userid]
		@user.get_completed
		if @user.get_completed[0] == "t"
			redirect '/student/score'
		end
		if session[:userid] == nil
			redirect "student/login"
		end
		erb :'pages/review_questions'
	end

	post '/student/score' do
		@user = User.new
		@user.userid = session[:userid]
		@user.complete_test
		redirect '/student/score'
	end

	get '/student/score' do
		if session[:userid] == nil
			redirect "student/login"
		end
		@totalscore = 0;
		@score = 0;
		@countcorrect = 0;
		@countincorrect = 0;
		@score = Checkanswer.new
		@score.studenttestid = session[:testid]
		@checks = @score.all
		@posiblescore = @score.get_all_questions
		@checks.each do |check|
		@givescore = check.questionscore.to_i
		correctanswer = check.correctanswer
		givenanswer = check.studentanswer
		correctanswer_str = correctanswer.split(' ').sort
		givenanswer_str = givenanswer.split(' ').sort
			if (correctanswer_str.length === givenanswer_str.length) && (correctanswer_str === givenanswer_str)
						@totalscore += @givescore
						@countcorrect = @countcorrect + 1;
			else(correctanswer_str != givenanswer_str)
						@countincorrect += 1;
			end
		@posiblescore.each do |score|
			@questions = score.countquestion.to_i
			@maxscore = score.maxscore.to_i
		end
		@unanswered = @questions - @countincorrect - @countcorrect
		@finalscore =  ((@totalscore / @maxscore.to_f) * 100).round(1)
		if @finalscore >= 60
			@feedback = "PASS"
		else
			@feedback = "FAIL"
		end
		@firstname = check.firstname
		@lastname = check.lastname
		end
		erb :'pages/score_page'
	end

	#admin route
	get '/admin/login' do
		erb :'pages/admin_login'
	end

	get '/admin/search' do
		erb :'pages/admin_search'
	end

	get '/admin/score' do
		erb :'pages/score_page'
	end

end
