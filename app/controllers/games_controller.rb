require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a[rand(0..25)]
    end
  end

  def score
    @word = params[:word]
    @grid = params[:letters].gsub(/\s+/, '').chars
    if !grid?(@word, @grid)
      @result = 1
    elsif !valid?(@word)
      @result = 2
    end
  end

  private

  def grid?(word, grid)
    word_arr = word.upcase.chars
    (word_arr & grid).flat_map do |n|
      [n] * [word_arr.count(n), grid.count(n)].min
    end.sort == word_arr.sort
  end

  def valid?(word)
    url = 'https://wagon-dictionary.herokuapp.com/' + word
    response = open(url).read
    data = JSON.parse(response)
    data['found']
  end
end
