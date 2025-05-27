require 'io/console'
class Board
  def initialize(word)
    @word = word.downcase
    @game_over = false
    #puts "Welcome to Board! the word is #{@word}"
    @failures = 0
    @guess_log = []
    @guess = Array.new(word.length, '_')
    draw_board
    until @game_over
      make_guess
      draw_board
      if @failures >= 10 
        puts "\nYou lose! the word was '#{@word}'".red
        @game_over = true
      elsif 
        @guess.include?('_') == false
        @game_over = true
        puts "\nYou win!".light_yellow
      end
    end
  end
  def draw_board
    puts "\nYou have #{@failures} wrong guesses so far. You lose if you hit 10 wrong guesses\n\n"
    p @guess.join
  end
  def make_guess
    valid_guess = false
    puts "\nWhat letter would you like to guess?"
    Signal.trap("INT") do
      puts "\nGoodbye!"
      exit
    end
    until valid_guess do
      char = STDIN.getch
      if char =~ /[a-zA-Z]/
        puts "\nYou typed: #{char}"
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
      puts "\nCORRECT! #{char} is indeed part of this word!".green
      return true
    end
    @failures += 1
    puts "\nWRONG! #{char} is not on the board! You have failed #{@failures} times so far.".red
    false
  end
end