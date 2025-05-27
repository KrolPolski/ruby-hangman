require 'colorize'
require_relative 'board'
class Hangman
  def initialize
    @word_bank = []
    greet
    load_words
    Board.new(choose_word)
  end

  def greet
    puts 'Welcome to Hangman!'.light_yellow
  end

  def load_words
    word_file = open('google-10000-english-no-swears.txt')
    word = word_file.gets.chomp
    until word.nil?
      @word_bank.push(word)
      word = word_file.gets
      word = word.chomp if word
    end
  end

  def choose_word
    word = @word_bank.sample
    word = @word_bank.sample until word.length >= 5 && word.length <= 12
    word
  end
end

Hangman.new
