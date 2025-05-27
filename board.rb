require 'io/console'
class Board
  def initialize(word)
    @word = word.downcase
    @game_over = false
    puts "Welcome to Board! the word is #{@word}"
    @failures = 0
    @guess_log = []
    @guess = Array.new(word.length, '_')
    draw_board
    until @game_over
      make_guess
      draw_board
      if @failures >= 10 
        puts 'You lose!'
        @game_over = true
      elsif 
        @guess.include?('_') == false
        @game_over = true
        puts 'You win!'
      end
    end
  end
  def draw_board
    puts "You have #{@failures} wrong guesses so far. You lose if you hit 10 wrong guesses"
    p @guess.join
  end
  def make_guess
    valid_guess = false
    puts "What letter would you like to guess?"
    Signal.trap("INT") do
      puts "\nGoodbye!"
      exit
    end
    until valid_guess do
      char = STDIN.getch
      if char =~ /[a-zA-Z]/
        puts "\nYou pressed: #{char} woo"
        char = char.downcase
        if @guess_log.include?(char) == false
          valid_guess = true
          @guess_log.push(char)
          check_guess(char)
        else
          puts "You already guessed #{char}. Choose something else."
        end
      elsif char == "\u0003" || char.ord == 3
        puts "\nGoodbye!"
        exit
      else
        puts "#{char} isn't a letter. What are you trying to pull?"
      end
    end
  end
  def check_guess(char)
    if @word.include?(char)
      @word.chars.each_with_index do |c, index|
        if c == char
          @guess[index] = char
        end
      end
      return true
    end
    @failures += 1
    false
  end
end