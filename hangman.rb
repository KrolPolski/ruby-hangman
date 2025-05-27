require 'colorize'
require_relative 'board.rb'
class Hangman
  def initialize
    @word_bank = []
    greet
    load_words
    Board.new(choose_word)
  end

  def greet
    puts "Welcome to Hangman!".light_yellow
  end

  def load_words
    word_file = open('google-10000-english-no-swears.txt')
    word = word_file.gets.chomp
    until word.nil?
      @word_bank.push(word)
      word = word_file.gets
      if word
        word = word.chomp
      end
    end
    #puts @word_bank
  end
  def choose_word
    word = @word_bank.sample
    until word.length >= 5 && word.length <= 12
      word = @word_bank.sample
    end
    #puts word
    return word
  end
end

game = Hangman.new;