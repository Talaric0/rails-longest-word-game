require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    letters_array = ("A".."Z").to_a
    @letters = []
    10.times { @letters << letters_array.sample }
    @letters
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @init_time = params[:TimeStampInitial].to_i
    @final_time = Time.now.to_i
    attempt_array = @word.split(//)
    validated_on_grid = attempt_array.all? { |char| @word.count(char) <= @letters.count(char.upcase) }
    
    filepath = "https://wagon-dictionary.herokuapp.com/#{@word}"
    dictionary_api_result = JSON.parse(open(filepath).read)

    validated_on_dictionary = dictionary_api_result["found"]

    @result = {}
    @result[:time] = @final_time - @init_time
    @result[:score] = 0
    @result[:score] = attempt_array.size + (1.0 / @result[:time]) if validated_on_dictionary && validated_on_grid
    @result[:message] = message_builder(@result[:score], validated_on_dictionary, validated_on_grid)
    @result
  end

  def message_builder(score, english, grid_check)
    return "Well done" if score.positive?
    return "not in the grid" if grid_check == false
    return "not an english word" if english == false
  end

  
  
end
