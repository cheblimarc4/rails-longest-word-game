class GamesController < ApplicationController
  require 'open-uri'
  require 'json'
  def new
    @letters = []
    pool = ("A".."Z").to_a
    while @letters.size < 10
      letter = pool.sample
      @letters << letter
    end
  end

  def score

    letters = params[:letters].split(' ')
    attempt = params[:guess]
    if !verify_grid(attempt, letters)
      @answer = "Sorry but #{attempt.capitalize} cant be built out of #{letters}"
    elsif verify_grid(attempt, letters) & !verify_word(attempt)
      @answer = "Sorry but #{attempt.capitalize} does not seem to be a valid English word"
    elsif verify_grid(attempt, letters) & verify_word(attempt)
      @answer = "Congratulations! #{attempt.capitalize} is a valid English Word!"
    end

  end


  def verify_grid(attempt, letters)
    letters = letters.map { |let| let.downcase }
    attempt.chars.all? { |let| attempt.count(let) <= letters.count(let) }
  end

  def verify_word(attempt)
    url = "https://dictionary.lewagon.com/#{attempt}"
    serialized = URI.open(url).read
    user = JSON.parse(serialized)
    return user["found"]
  end


end
