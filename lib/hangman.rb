# frozen_string_literal: true

require 'psych'

# Player class gets users guess
class Player
  def self.user_guess
    puts 'select a letter from a-z or type save if you wish to save-savename. type load-savename to load save'
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
    puts @line_to_fill
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
    @computer = Computer.new
  end

  def save_game(save_name)
    save_directory = "#{Dir.home}/Documents/saves"
    data_to_save = Psych.dump({
      letters_guessed: @computer.line_to_fill,
      secret_word: @computer.secret_word,
      count: @count
      })
    File.write("#{save_directory}/#{save_name.slice(5, save_name.length - 1)}.yaml", data_to_save)
  end

  def load_game(save_name)
    save_file = save_name.slice(5, save_name.length - 1)
    puts "#{save_name.slice(5, save_name.length - 1)} loaded"
    loaded_data = Psych.load_file("#{Dir.home}/Documents/saves/#{save_file}.yaml")
    @computer.line_to_fill = loaded_data[:letters_guessed]
    @count = loaded_data[:count]
    @computer.secret_word = loaded_data[:secret_word]
  end

  def file_check(file_name)
    File.exist?(file_name.to_s)
  end

  def make_save_directory
    Dir.mkdir(File.join(Dir.home, 'Documents', 'saves'), 0700) unless Dir.exist?("#{Dir.home}/Documents/saves")
    puts 'save folder created'
  end

  def condition_check(computer, player_guess)
    if @computer.guess_check(player_guess)
      @computer.fill_blank_space(player_guess)
    elsif player_guess.include?('save-'.downcase)
      save_game(player_guess)
    elsif @count == 6
      puts "you lose the secret word was: #{computer.secret_word}"
    elsif @computer.line_to_fill == computer.secret_word
      puts "you have guessed the word #{computer.secret_word}, you win"
    elsif player_guess.include?('load-'.downcase)
      load_game(player_guess)
    elsif !@computer.guess_check(player_guess)
      puts "the word does not contain this letter increasing count: #{@count}"
    end
  end

  def play
    make_save_directory
    puts 'welcome to hangman. If the count reaches 6 you lose.'
    loop do
      player_guess = Player.user_guess
      condition_check(@computer, player_guess)
    end
  end
end

Game.new.play
