require 'telegram/bot'
require 'net/http'
require 'uri'

class BotController < ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    dispatcher(params)

    render body: nil, head: :ok
  end

  def check_command
  	if true
  		"lol"
  	end
  end

  def dispatcher(params)
    ttoken = 'bot309984878:AAG2sTeB3TiQA-7d-AyntSle1o2i6KegGBA' #MCS-Bot
    token = '366193367:AAH1-G2EtqJmbbKRnwcUyhmuNdRBT11Ry1I' #Ice Debug Bot
    chat_id = params["message"]["chat"]["id"]
    #chat_id = '136040524'
    #if params["message"].present?
    #	chat_id = params["message"]["from"]["id"]
    #else
    #	chat_id = '136040524'
    #end

    text = "PAU NO SEU CU!"
    #text = chat_id = params["message"]["chat"]["id"]

    bot = Telegram::Bot::Client.new(token)
    bot.send_message chat_id: chat_id, text: text
    #bot.request(:getMe)
    #raise (bot.methods).inspect
    #bot.request(:getMe)
    #bot.get_me

		#"message"=>{"message_id"=>170, 
		#	"from"=>{"id"=>136040524, "first_name"=>"Elano", "last_name"=>"Garcez", "username"=>"icehaku"}, 
		#	"chat"=>{"id"=>136040524, "first_name"=>"Elano", "last_name"=>"Garcez", "username"=>"icehaku", "type"=>"private"}, 		"date"=>1489895600, "text"=>"olah!"}, 
		#	"lol"=>{"update_id"=>6947171,

 		#"message"=>{"message_id"=>227, 
 		#	"from"=>{"id"=>136040524, "first_name"=>"Elano", "last_name"=>"Garcez", "username"=>"icehaku"}, 
 		#	"chat"=>{"id"=>-212554450, "title"=>"Eu e Meus Bot!", "type"=>"group", "all_members_are_administrators"=>true}, "date"=>1489937306, "text"=>"bot imundo!"}, 
 		#"bot"=>{"update_id"=>6947200, 
 		#	"message"=>{"message_id"=>227, "from"=>{"id"=>136040524, "first_name"=>"Elano", "last_name"=>"Garcez", "username"=>"icehaku"}, "chat"=>{"id"=>-212554450, "title"=>"Eu e Meus Bot!", "type"=>"group", "all_members_are_administrators"=>true}, "date"=>1489937306, "text"=>"bot imundo!"}}}


		#URI.encode("Hello there world")
		#=> "Hello%20there%20world"
		#URI.encode("hello there: world, how are you")
		#=> "hello%20there:%20world,%20how%20are%20you"

		#URI.decode("Hello%20there%20world")
  end

  def dispatcher_bruto(params)
    token = 'bot309984878:AAG2sTeB3TiQA-7d-AyntSle1o2i6KegGBA' #MCS-Bot
    ttoken = 'bot366193367:AAH1-G2EtqJmbbKRnwcUyhmuNdRBT11Ry1I' #Ice Debug Bot
    #api = Telegram::Bot::Api.new(token)
    action = 'sendMessage'
    chat_id = params["message"]["from"]["id"]
    #chat_id = '136040524'
    text = 'PAU NO SEU CU!'
    text = "&text=#{text}!"
    #api.call('sendMessage', chat_id: '136040524', text: "pau no seu cu!")
    url = "https://api.telegram.org/#{token}/#{action}?chat_id=#{chat_id}#{text}"
    #raise (url).inspect

		uri = URI(url)
		req = Net::HTTP.get(uri)
		req = JSON.parse(req) 
  end

	def giant_bomb(param)
		raise "giant_bomb"
		#59e98768f1acb8d1f21981da6b89efb61acd7001
		#http://www.giantbomb.com/api/games/?api_key=59e98768f1acb8d1f21981da6b89efb61acd7001&platforms=&sort=date_added:desc&field_list=date_added,deck,id,image,name,platforms&limit=10&offset=0&format=json
	end

	def igdb(param)
		raise "igdb"
		#https://www.igdb.com/
	end
end
