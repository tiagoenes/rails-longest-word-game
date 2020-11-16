require 'open-uri'
require 'json'


class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end
  def score
    @input = params[:inserted]
    start_time = Time.parse params[:start_time]
    @letters = params[:letters]
    puts start_time
    end_time = Time.now
    if @input
      @result = run_game(@input,@letters.chars,start_time,end_time)

    end
  end

  private
  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    # random_letters = (0..grid_size - 1).map { ('a'..'z').to_a[rand(26)] }
    random_letters = (0...grid_size).map { ("a".."z").to_a.sample }
    return random_letters
  end

  def run_game(attempt, grid, start_time, end_time)
    # p "#{attempt} - #{grid} - #{start_time} - #{end_time}"
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    url = 'https://wagon-dictionary.herokuapp.com/'
    wagon_dictionary = open("#{url}#{attempt}").read
    word_exist = JSON.parse(wagon_dictionary)["found"]
    result = attempt_in_grid(attempt.downcase, grid.map(&:downcase)) == attempt.size

    if word_exist && result
      { time: end_time - start_time, score: (attempt.size * 200 / (end_time - start_time)), message: "well done" }
    else
      word_exist ? message = "not in the grid" : message = "not an english word"
      { time: end_time - start_time, score: 0.to_i, message: message }
    end
  end

  def attempt_in_grid(attempt, grid)
    # splited_grid = grid.split("")
    splited_attemp = attempt.split("")
    attemp_in_grid = splited_attemp.count do |e|
      grid.delete_at(grid.index(e)) if grid.include?(e)
    end
    return attemp_in_grid
  end
end


