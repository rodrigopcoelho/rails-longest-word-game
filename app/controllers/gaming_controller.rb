require "open-uri"

class GamingController < ApplicationController

  def game
    letter = ('A'..'Z').to_a.shuffle
    @letters = []
    10.times do
      @letters.push(letter.sample)
    end
  end

  def score
    @word = params[:guess]
    @letters = params[:letters].split("")

    @word = @word.downcase
    @letters = @letters.map(&:downcase)

    word_chars = @word.chars
    @result = word_chars.all? { |char| @letters.include?(char) } && word_chars.all? { |char| @letters.count(char) >= @word.count(char) }
    @quote = ""

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    @fetched = JSON.parse(URI.open(url).read)
    @ansewr = @fetched["found"] == true

    if @result && @ansewr
      @quote = "Congratulations! #{@word} is a valid English word!"
    elsif @result
      @quote = "Sorry but #{@word} does not seem to be a valid English word..."
    else
      @quote = "Sorry but  #{@word} can't be built out of  #{@letters.join('')}"
    end
  end
end
