module InlineBot
  extend ActiveSupport::Concern

  def inline(params)
    token = '350328660:AAGWpPvLjrHihatk_OhCioDWGHEyjYh2Pts' #Metacritic Game Score Bot
    bot = Telegram::Bot::Client.new(token)
print "lul1"
    if params["inline_query"].present?
      inline_query_id = params["inline_query"]["id"]
      query = params["inline_query"]["query"]
    end

    url = URI.encode("http://www.metacritic.com/search/all/#{query}/results")
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
print "lul2"
    begin
      html_result = Nokogiri::HTML(open(url, 'User-Agent' => user_agent), nil, "UTF-8")
    rescue Exception => e
      print e.message
      html_result = nil
    end
print "lul3"
    if html_result.present?
      html_result = html_result.css("ul.search_results").css("li")
print "lul4"
      games = parse_scraped_games(html_result)
      telegram_inline_result = create_telegram_inline_result(games)

      bot.answer_inline_query inline_query_id: inline_query_id, results: telegram_inline_result
print "lul5"      
    end
  end


  def parse_scraped_games(results)
    games = []

    results.each do |result|
      print "lul7"
      if result.css("div.result_wrap").css("div.basic_stats").css("div.main_stats").css("p").text.include?("Game")
        print "lul6"
        game = Hash.new()
        game["name"] = result.css("div.result_wrap").css("div.basic_stats").css("div.main_stats").css("h3").css("a").text.strip rescue ""
        game["release"] = "XX/XX"
        #result.css("li.stat.release_date").css("span.data").text
        game["platform"] = result.css("div.result_wrap").css("div.basic_stats").css("div.main_stats").css("p").css("span").text rescue ""
        game["metascore"] = result.css("div.result_wrap").css("div.basic_stats").css("div.main_stats").css("span").first.text rescue ""
        game["description"] = result.css("div.result_wrap").css("p.deck").text rescue ""
        game["url"] = result.css("div.result_wrap").css("div.basic_stats").css("div.main_stats").css("h3").css("a").attribute("href").text rescue ""
        game["url"] = "http://www.metacritic.com#{game["url"]}"
        game["image"] = result.css("div.result_wrap").css("div.result_thumbnail").css("img").first.attribute("src").text rescue ""
        #if game["metascore"].present?
        #  game["image"] = set_metascore_image(game["metascore"])
        #  game["metascore"] = "#{game['metascore']}"
        #else
        #  game["image"] = "http://www.headslinger.com/feed_img/1000565.jpg"
        #end
        #game["image_userscore"] = get_metacritic_image_userscore_by_url(game["url"])

        games << game
      end
    end

    return games
  end


  def get_metacritic_image_userscore_by_url(url)
    begin
      user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
      url = "http://www.metacritic.com#{url}"
      page = Nokogiri::HTML(open(url, 'User-Agent' => user_agent), nil, "UTF-8")
      image = page.css("img.product_image.large_image")[0].values[1]
      userscore = page.css("div.product_scores").css("div.metascore_w.user.large.game")[0].text
      [image, userscore]
    rescue
      ["", ""]
    end
  end


  def set_metascore_image(score)
    grade = score.to_i

    if grade > 75
      "https://placeholdit.imgix.net/~text?txtsize=33&txt=#{score}&150&w=75&h=75&bg=33cc33&txtclr=ffffff"
    elsif grade > 45
      "https://placeholdit.imgix.net/~text?txtsize=33&txt=#{score}&150&w=75&h=75&bg=fed731&txtclr=ffffff"
    else
      "https://placeholdit.imgix.net/~text?txtsize=33&txt=#{score}&150&w=75&h=75&bg=cc0000&txtclr=ffffff"
    end
  end


  def create_telegram_inline_result(games)
    print "lul9"
    games.map.with_index do |game, index|
      {
        type: "article",
        title: "#{game['name']}(#{game['platform']}) MS:#{game['metascore']}",
        id: index.to_s,
        description: game["description"],
        thumb_url: game["image"],
        input_message_content: {
          parse_mode: "HTML",
          message_text: "\xF0\x9F\x91\xBE <b>#{game['name']}</b>\n<b>Console</b>: #{game['platform']}\n<b>Metascore</b>: #{game['metascore']}\n<b>Release</b>: #{game['release']}\n#{game['description']}\n#{game['url']}",
        },
      }
    end
  end

end
