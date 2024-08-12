require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters.push(('A'..'Z').to_a.sample)
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def score
    @input = params[:input]
    @array = params[:array].split(' ')
    # raise

    url = "https://dictionary.lewagon.com/#{params[:input]}"
    html_file = URI.open(url).read # rubocop:disable Security/Open
    html_doc = JSON.parse(html_file)
    if html_doc['found'] == true
      if @input.upcase.split('').all? { |e| @array.include?(e) }
        @message = "Congratulations! 🎉 '#{@input}' is a valid English word!"
      else
        @message = "Sorry, but '#{@input}' can't be built out of #{@array.join(', ')}. 🔡"
      end
    else
      @message = "Sorry, but '#{@input}' does not seem to be a valid English word. 🤷🏻‍♂️"
    end
  end
end

