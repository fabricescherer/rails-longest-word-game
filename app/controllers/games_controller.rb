require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    9.times do |letter|
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @answer = params[:answer]
    if included?(@answer.upcase, params[:letters])
      if english_word?(@answer)
        @included = "Congratulation! #{@answer.upcase} is a valid English Word!"
      else
        @included = "Sorry but #{@answer.upcase} does not seem to be an English word..."
      end
    else
      @included = "Sorry but #{@answer.upcase} can't be built out of #{params[:letters]}"
    end
  end

  def included?(guess, letters)
    guess.chars.all? { |letter| guess.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
