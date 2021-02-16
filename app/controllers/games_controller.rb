require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    charset = Array('A'..'Z')
    @letters = Array.new(10) { charset.sample }
  end

  def english_word?(word)
    raw_json = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    json_hash = JSON.parse(raw_json)
    json_hash['found'] == true
  end

  def word_check(word, letters)
    word.upcase.chars.all? do |char|
      letters.include?(char) && word.count(char) <= letters.count(char)
    end
  end

  def score
    word = params['word']
    letters = params['letters']

    if english_word?(word) == true && word_check(word, letters) == true
      @word_result = "#{word.upcase} is a good word!" # the variable is just container. logic will run in controller first
    elsif english_word?(word) == false
      @word_result = "Sorry #{word.upcase} is not an English word!"
    elsif word_check(word, letters) == false
      @word_result = "Sorry #{word.upcase} cannot be built out of #{letters}!"
    end
  end
end
