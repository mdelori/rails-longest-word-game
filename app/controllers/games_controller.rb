require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = [*'A'..'Z'].sample(10)
  end


  def score
    @score = params[:score].upcase
    @letters = params[:letters].split(" ")
    in_grid = @score.chars.all? {|letter| @letters.include?(letter) }
    @congratulation = ''

    @score.chars do |user_letter|
      @letters.include? user_letter
    end

    is_english = in_dictionary?(@score)

    if in_grid && is_english
      @congratulation = "Congratulations!"
    elsif is_english == false
      @congratulation = "Your word is not in the dictionary... Try again!"
    else
      @congratulation = "Sorry but #{@score} can't be built out of #{@letters}..."
    end
  end


  private

  def in_dictionary?(score)
    url = "https://wagon-dictionary.herokuapp.com/#{score}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end
end
