# frozen_string_literal: true

# Player class gets users guess
class Player
  attr_accessor :guess

  def initialize
    @guess = ''
  end

  def user_guess
    puts 'select a letter from a-z'
    @guess = gets.chomp.downcase
  end
end

# Computer class gets secret word from file and checks the users guess against word and decides what to do
class Computer
  attr_accessor :secret_word, :line_to_fill

  def initialize
    @secret_word = ''
    @line_to_fill = ''
  end

  def choose_secret_word
    words = open_word_file
    @secret_word = words[Random.new.rand(0..words.length - 1)].downcase
  end

  def open_word_file
    File.readlines('google-10000-english-no-swears.txt', chomp: true)
  end

  def guess_check(player_guess)
    @secret_word.include?(player_guess)
  end

  def update_blank_line
    @line_to_fill.rjust(@secret_word.length, '_')
  end

  def fill_blank_space(player_guess)
    letter_to_fill = letter_position(player_guess)
    @line_to_fill = @line_to_fill.split(//)
    letter_to_fill.each { |letter| @line_to_fill[letter] = player_guess }
  end

  def letter_position(player_guess)
    @secret_word.split(//).each_with_index.select { |letter| letter == player_guess }
  end
end

# game  creates players and calls functions where needed
class Game
  def initialize
    @player = Player.new
    @computer = Computer.new
    @count = 1
  end

  def save_game
    Dir.mkdir('/saves')
    if file_check("save#{count}")
      puts 'do you wish to overwrite the save file'
      if(gets.chomp.downcase == 'yes')
        File.write("save#{count}")
      end
    end
    File.new("/saves/save#{@count += 1}")
  end

  def file_check(file_name)
    File.exist?(file_name.to_s)
  end
end