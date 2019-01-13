require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/cookies'
require 'pg'
require_relative './controller/sql_controller.rb'
require_relative './models/Question.rb'
require_relative './models/Answer.rb'
require_relative './models/Login.rb'

use Rack::Reloader

use Rack::MethodOverride

run SqlController