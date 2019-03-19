class HomepageController < ApplicationController
  require 'open-uri'
  require 'json'

  def home
  	@firstimgs = scrape_first_imgs.shuffle!
  	@restimgs = scrape_rest_imgs.shuffle!
  	@quotes = scrape_quotes.shuffle!
  	@index = 0
  end

  def download_resume
  	send_file "public/Juwon_Cha_Resume.pdf", type: "application/pdf", x_sendfile: true
  end

  #github.com/saadq
  def scrape_first_imgs
    url = "https://reddit.com/r/earthporn/top.json?sort=top&t=all&limit=1000&before=t3_6vz211"
    res = open(url, "User-Agent" => "Ruby/#{RUBY_VERSION}").read
    reddit_json = JSON.parse(res)

    images = []

    reddit_json['data']['children'].length.times do |n|
      img = {
        title:    reddit_json['data']['children'][n]['data']['title'],
        img_url:  reddit_json['data']['children'][n]['data']['url'],
        post_url: reddit_json['data']['children'][n]['data']['permalink'],
        width: reddit_json['data']['children'][n]['data']['preview']['images'][0]['source']['width']
      }

      if valid_img?(img) && img[:width] > 1500 && !img[:title].include?("tulips") && !img[:title].include?("Texas") && !img[:title].include?("Phases") 

        normalize_url(img[:img_url])
        images << img
      end
    end

    images
  end

  def scrape_quotes
    url = "https://reddit.com/r/todayilearned/top.json?sort=top&t=all&limit=1000"
    res = open(url, "User-Agent" => "Ruby/#{RUBY_VERSION}").read
    reddit_json = JSON.parse(res)

    quotes = []

    reddit_json['data']['children'].length.times do |n|
      quote = {
        title:    reddit_json['data']['children'][n]['data']['title'],
        post_url: reddit_json['data']['children'][n]['data']['permalink']
      }

      normalize_title(quote)
      if quote[:title].length < 270
      	quotes<<quote
      end
    end

    scrape_more_quotes.each do |quote|
    	quotes<<quote
    end
    quotes
  end

  def scrape_more_quotes
  	url = "https://www.reddit.com/r/todayilearned/top.json?sort=top&t=all&limit=100&after=t3_axrxwf"
  	res = open(url, "User-Agent" => "Ruby/#{RUBY_VERSION}").read
    reddit_json = JSON.parse(res)

    quotes = []

    reddit_json['data']['children'].length.times do |n|
      quote = {
        title:    reddit_json['data']['children'][n]['data']['title'],
        post_url: reddit_json['data']['children'][n]['data']['permalink']
      }

      normalize_title(quote)
      if quote[:title].length < 270
      	quotes<<quote
      end
    end

    quotes
  end

  def scrape_rest_imgs
    url = "https://reddit.com/r/earthporn/top.json?sort=top&t=all&limit=1000&after=t3_6vz211"
    res = open(url, "User-Agent" => "Ruby/#{RUBY_VERSION}").read
    reddit_json = JSON.parse(res)

    images = []

    reddit_json['data']['children'].length.times do |n|
      img = {
        title:    reddit_json['data']['children'][n]['data']['title'],
        img_url:  reddit_json['data']['children'][n]['data']['url'],
        post_url: reddit_json['data']['children'][n]['data']['permalink'],
        width: reddit_json['data']['children'][n]['data']['preview']['images'][0]['source']['width']

      }

      if valid_img?(img) && img[:width] > 1800
        normalize_url(img[:img_url])
        images << img
      end
    end

    scrape_more_images.each do |img|
    	images<<img
    end
    images
  end

  def scrape_more_images
  	url = "https://reddit.com/r/earthporn/top.json?sort=top&t=all&limit=1000&after=t3_7whpvs"
    res = open(url, "User-Agent" => "Ruby/#{RUBY_VERSION}").read
    reddit_json = JSON.parse(res)

    images = []

    reddit_json['data']['children'].length.times do |n|
      img = {
        title:    reddit_json['data']['children'][n]['data']['title'],
        img_url:  reddit_json['data']['children'][n]['data']['url'],
        post_url: reddit_json['data']['children'][n]['data']['permalink'],
        width: reddit_json['data']['children'][n]['data']['preview']['images'][0]['source']['width']

      }

      if valid_img?(img) && img[:width] > 1800
        normalize_url(img[:img_url])
        images << img
      end
    end

    images
  end

  def normalize_title(quote)
  	quote[:title] = quote[:title][4..]
	if quote[:title][0] == ' ' || quote[:title][0] == ":"
		quote[:title] = quote[:title][1..]
	end
  	if quote[:title][0..3] == 'that'
  		quote[:title] = quote[:title][5..]
  	end
  	if quote[:title][0] == " " || quote[:title][0] == ":"
  		quote[:title] = quote[:title][1..]
  	end
  	quote[:title][0] = quote[:title][0].upcase
  	length = quote[:title].length
  	if quote[:title][length - 1] != "." && quote[:title][length - 2] != "."
  		quote[:title] << "."
  	end
  	if quote[:title][0..1] == "Of"
  		quote[:title] = quote[:title][3..]
  		quote[:title][0] = quote[:title][0].upcase
  	end
  end

  # Checks to see if the image url is an
  # imgur link and that it is only a single image
  def valid_img?(img)
    img != nil &&
    !img.empty? &&
    (imgur?(img) || ireddit?(img))
  end

  # Checks to see if the image url is an imgur link
  def imgur?(img)
    img[:img_url][7..11] == 'imgur' ||
    img[:img_url][7..11] == 'i.img' ||
    img[:img_url][7..11] == 'm.img'
  end

  # Checks to see if the image url is an ireddit link
  def ireddit?(img)
    img[:img_url][8..16] == 'i.redd.it'
  end

  # Normalizes an imgur url to start with i.imgur
  def normalize_url(img_url)
    if img_url[7..11] == 'imgur'
      img_url.insert(7, 'i.')
      img_url << ".jpg"
    end
  end
end
