# frozen_string_literal: true

require 'psych'

# Player class gets users guess
class Player
  def self.user_guess
    puts 'select a letter from a-z'
    gets.chomp.downcase
  end
end

# Computer class gets secret word from file and checks the users guess against word and decides what to do
class Computer
  attr_accessor :line_to_fill, :secret_word

  def initialize
    @secret_word = choose_secret_word
    @line_to_fill = ''.rjust(secret_word.length, '_')
  end

  def choose_secret_word
    words = open_word_file
    words[Random.new.rand(0..words.length - 1)].downcase
  end

  def open_word_file
    File.readlines('google-10000-english-no-swears.txt', chomp: true)
  end

  def guess_check(player_guess)
    secret_word.include?(player_guess)
  end

  def fill_blank_space(player_guess)
    letter_to_fill = letter_position(player_guess)
    @line_to_fill = @line_to_fill.split(//)
    letter_to_fill.each { |letter| @line_to_fill[letter] = player_guess }
    @line_to_fill = @line_to_fill.join
    @secret_word = @secret_word.join
    puts "line_to_fill1: #{@line_to_fill}"
  end

  def letter_position(player_guess)
    @secret_word = secret_word.split(//)
    @secret_word.each_index.select { |letter| @secret_word[letter] == player_guess }
  end

  def win_condition
    @line_to_fill == @secret_word
  end
end

# game  creates players and calls functions where needed
class Game
  attr_accessor :count

  def initialize
    @count = 0
  end

  def save_game
    save_directory = "#{Dir.home}/Documents/saves"
    save_count = 1
    data_to_save = Psych.dump({
      letters_guessed: computer.line_to_fill,
      secret_word: computer.secret_word,
      count: count
      })
    make_save_directry
    puts 'type yes to overwrite save'
    if file_check("#{save_directory}/save#{save_count}.yaml") && gets.chomp.downcase == 'yes'
      File.write("#{save_directory}/save#{save_count}.yaml", data_to_save)
    end
    File.new("#{save_directory}/save#{save_count += 1}.yaml", data_to_save)
  end

  def file_check(file_name)
    File.exist?(file_name.to_s)
  end

  def make_save_directry
    if Dir.exist?("#{Dir.home}/Documents/saves")
      Dir.mkdir("#{Dir.home}/Documents/saves")
    end
  end

  def play
    computer = Computer.new
    puts 'welcome to hangman. If the count reaches 6 you lose'
    loop do
      player_guess = Player.user_guess
      if computer.guess_check(player_guess)
        computer.fill_blank_space(player_guess)
      else
        @count += 1
        puts "incorrect: #{@count}"
      end
      if computer.win_condition 
        puts "you have guessed the correct word #{@secret_word}"
        break
      elsif @count == 6
        puts "you have not guessed the correct word #{@secret_word}"
        break
      end
    end
  end
end

Game.new.play
