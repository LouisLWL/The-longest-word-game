require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a[rand(26)] }.join(" ")
  end

  def score
    @word = params[:word]
    api = open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    json = JSON.parse(api)
    is_english = json["found"]
    incl = include

    if is_english && incl
      @result = "Congratulations! #{@word.upcase} is an English word and is included in the grid!"
      @score = @word.length
    elsif is_english
      @result = "Congratulations! #{@word.upcase} is an English word! But does is not included in the grid: #{params[:letters]}"
      @score = 0
    elsif incl
      @result = "Congratulations! #{@word.upcase} is in the grid! But does is not an English word."
      @score = 0
    else
      @result = "Sorry but #{@word.upcase} does not seem to be a vaid English word nor in the grid..."
      @score = 0
    end
  end

  private

  def include
    checking = true
    split_word = @word.split("")
    lets = params[:letters].split("")
    split_word.all? do |letter|
      lets.include?(letter) && checking
    end
  end
end
