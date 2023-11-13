require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    alphabet = ('a'..'z').to_a
    @letters = []
    10.times { @letters << alphabet[rand(alphabet.size)] }
  end

  def score
    @allowed_letters = params[:letters].split
    @used_letters = params[:word].split("")
    @valid_letters = used_letters_in_letters?(@used_letters, @allowed_letters)
    @valid_word = is_valid_word?(@used_letters.join)
    @message = ""
    @message = "#{@used_letters.join} is not a valid English word}" unless @valid_word
    @message = "#{@used_letters.join} cant be built out of #{@allowed_letters}" unless @valid_letters
    @message = "Congratulations! #{@used_letters.join} is a valid English word!" if @valid_letters && @valid_word
  end

  private

  def used_letters_in_letters?(used_letters, allowed_letters)
    used_letters.each do |letter|
      if allowed_letters.include? letter
        allowed_letters.delete letter
      else
        return false
      end
    end
    return true
  end

  def is_valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    serialized = URI.open(url).read
    parsed = JSON.parse(serialized)
    return parsed["found"]
  end
end
