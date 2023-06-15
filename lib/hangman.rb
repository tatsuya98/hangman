# frozen_string_literal: true

# Player class gets users guess
class Player
  attr_accessor :guess

  def initialize
    @guess = ''
  end

  def user_guess
    @guess = gets.chomp
  end
end

# Computer class gets secret word from file and checks the users guess against word and decides what to do
class Computer
  attr_accessor :secret_word

  def initialize
    @secret_word = ''
  end

  def choose_secret_word
    words = open_word_file
    @guess = words[Random.new.rand(0..words.length - 1)]
  end

  def open_word_file
    File.readlines('google-10000-english-no-swears.txt', chomp: true)
  end

end