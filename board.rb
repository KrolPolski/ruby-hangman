require 'io/console'
require 'yaml'
class Board
  def initialize(word)
    @word = word.downcase
    @game_over = false
    puts "\n You can save by pressing CTRL-S at any time."
    @failures = 0
    @failure_log = []
    @guess_log = []
    @guess = Array.new(word.length, '_')
    draw_board
    game_loop
  end
  def game_loop
    until @game_over
      make_guess
      draw_board
      if @failures >= 10 
        puts "\nYou lose! the word was '#{@word}'".red
        @game_over = true
      elsif @guess.include?('_') == false
        @game_over = true
        puts "\nYou win!".light_yellow
      end
    end
  end
  def draw_board
    puts "\nYou have #{@failures} wrong guesses so far. You lose if you hit 10 wrong guesses.\n\n"
    puts "Wrong answer collection: #{@failure_log}"
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
      elsif char == "\u0013"
        save_game
      elsif char == "\f"
        load_game
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
      puts "\nCORRECT! '#{char}' is indeed part of this word!".green
      return true
    end
    @failures += 1
    @failure_log.push(char)
    puts "\nWRONG! '#{char}' is not on the board! You have failed #{@failures} times so far.".red
    false
  end
  def save_game
    begin
    save_file = open('hangman.sav', 'w+')
    save_data = YAML.dump({
      :word => @word,
      :guess => @guess,
      :failures => @failures,
      :failure_log => @failure_log,
      :guess_log => @guess_log,
      :game_over => @game_over
    })
    save_file.puts save_data
    save_file.close
    puts "\nGame saved."
    rescue Errno::EACCES => e
      puts "\nError: Cannot save game. #{e.message}"
    rescue IOError => e
      puts "\nError: Could not write to file. #{e.message}"
    rescue StandardError => e
      puts "\nUnexpected error saving game: #{e.message}"
    end
  end
  def load_game
    save_file = 'hangman.sav'
    unless File.exist?(save_file) && !File.zero?(save_file)
      puts "\nNo saved game to load!"
      return nil
    end
    puts "\nGame loading."
    save_file = 'hangman.sav'
    save_data = YAML.unsafe_load_file(save_file, symbolize_names: true)
    @word = save_data[:word]
    @guess = save_data[:guess]
    @failures = save_data[:failures]
    @failure_log = save_data[:failure_log]
    @guess_log = save_data[:guess_log]
    @game_over = save_data[:game_over]
    puts "\nGame loaded."
    draw_board
  end
end