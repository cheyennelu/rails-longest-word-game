require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    charset = Array('A'..'Z')
    @letters = Array.new(10) { charset.sample }
  end

  def score
    word = params["word"]
    raw_json = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    json_hash = JSON.parse(raw_json)
    letters = params["letters"]

    word_check = word.upcase.chars.all? do |char|
      letters.include?(char) && word.count(char) <= letters.count(char)
    end

    if json_hash["found"] == true && word_check == true
      @word_result = "#{word.upcase} is a good word!" # the variable is just container. logic will run in controller first
    elsif json_hash["found"] == false
      @word_result = "Sorry #{word.upcase} is not an English word!"
    elsif word_check == false
      @word_result = "Sorry #{word.upcase} cannot be built out of #{letters}!"
    end
  end
end
