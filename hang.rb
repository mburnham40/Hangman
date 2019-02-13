
class Grid
    attr_accessor :h0, :h1, :h2, :h3, :h4, :h5, :h6, :h7, :grid

    def initialize
        @h0 = ['  ', ' _', '__', '  ', '  ', '  ', '  ', '  ', '  ', '  ']
        @h1 = ['  ', '|/', '  ', '| ', '  ', '  ', '  ', '  ', '  ', '  ']
        @h2 = ['  ', '| ', '  ', '  ', '  ', '  ', '  ', '  ', '  ', '  ']
        @h3 = ['  ', '| ', "  ", "  ", '  ', '  ', '  ', '  ', '  ', '  ']
        @h4 = ['  ', '| ', '  ', '  ', '  ', '  ', '  ', '  ', '  ', '  ']
        @h5 = ['  ', '| ', '  ', "  ", '  ', '  ', '  ', '  ', '  ', '  ']
        @h6 = ['  ', '| ', '  ', '  ', '  ', '  ', '  ', '  ', '  ', '  ']
        @h7 = [' /',"|\\", '  ', '  ', '  ', '  ', '  ', '  ', '  ', '  ']
        @grid = [@h0, @h1, @h2, @h3, @h4, @h5, @h6, @h7]
    end

    def draw
        vert_ind = 0
        while vert_ind < 8
            row = grid[vert_ind].join('')
            puts row
            vert_ind += 1
        end
    end

    def update(vert, horiz, current)
            grid[vert][horiz] = "#{current} "
    end

    def draw_hang(points, the_word, myst)
        has_lost = false
        wordy = the_word.chars

        if points == 0
            grid[1][4] = "   Nobody's on the noose..."
        elsif points == 1
            grid[2][3] = 'O '
            grid[1][4] = "   What a good day to not die!"
        elsif points == 2
            grid[3][3] = "| "
            grid[4][3] = '| '
            grid[1][4] = "   Such a fun guessing game..."
        elsif points == 3 
            grid[3][2] = " /"
            grid[1][4] = "   I should have stuck to that diet,"
            grid[2][4] = "   this rope is getting tight."
        elsif points == 4
            grid[5][2] = ' /'
            grid[1][4] = "   Alright, it's official, I'm starting"
            grid[2][4] = "   to choke..."
        elsif points == 5
            grid[3][3] = "|\\"
            grid[1][4] = "   Hhhckk!  ACKckcK!  EhHhH!"
            grid[2][4] = "   "
        elsif points == 6
            grid[5][3] = " \\"
            if $hint
                nummy = rand(wordy.length)
                hinty = wordy[nummy]
                while(myst[nummy] != "_")
                    nummy = rand(wordy.length)
                    hinty = wordy[nummy]
                end
                grid[1][4] = "   URP!  TRY THE LETTER #{hinty.upcase}!!!!!  HURRYYYY!!!"
                $hint = false
            else
                grid[1][4] = "   GLLUP!  NO... MORE... HINTS..."
                grid[2][4] = "   PLEASE... HELP...ME..."
            end
        else
            grid[1][4] = " "
            grid[2][4] = "   "
            grid[2][5] = " "
            grid[1][4] = " "
            grid[2][6] = "/ "
            grid[1][7] = "_"
            grid[2][7] = "\\<"
            grid[2][8] = "O/"
            grid[1][10] = "_"
            grid[2][9] = " \\"
            grid[4][4] = "   Shoot, I'm dead.  Nice job genius."
            grid[5][4] = "   Here come the vultures to pick at my bones."
        end
    end
end

class WordField
    attr_accessor :secret_word, :len, :mystery, :inde

    def initialize(secret_word)
        @secret_word = secret_word
        @len = secret_word.length
        @mystery = []
        @inde = 0
        while (inde < len)
            mystery[inde] = "_"
            @inde += 1
        end
    end

    def draw_mystery
        puts ""
        puts "Progress so far..."
        puts ""
        puts mystery.join(" ")
        puts ""
    end

    def letter_guess(guess)
        if secret_word.include? guess
            temp_arr = secret_word.chars
            puts ""
            ind = 0
            while ind < len
                if (temp_arr[ind] == guess)
                    mystery[ind] = guess
                end
                ind += 1
            end
        else
            return false
        end
    end

    def did_win?
        if mystery.include? "_"
            return false
        else
            return true
        end
    end

end

class JunkLetters
    attr_accessor :arr
    
    def initialize
        @arr = []
    end

    def add_letter(bad_letter)
        arr << bad_letter
    end

    def draw_bad_letters
        puts ""
        puts "These are the letters that aren't in the word..."
        puts ""
        split_arr = arr.join("  ")
        puts split_arr
        puts ""
        puts "---------------------------------------------"
        puts ""
    end

end

require 'fileutils'
count = 0
dict = File.read "5desk.txt"
bigArr = dict.split("\n")
word = "hmm"
while ((word.length < 5)||(word.length > 12))
    index = rand(bigArr.length)
    word = bigArr[index].downcase
end

my_grid = Grid.new
my_junk = JunkLetters.new
$hint = true
has_saved = false

if !(Dir.exists? "output")
    blanked_out_word = WordField.new(word)
    puts "There's nothing to load!"
else
    puts "Welcome Back!"
    puts ""
    load_arr = []
    load_arr_mystery = []
    load_arr_junk = []
    File.open("output/saved_stuff.txt").readlines.each do |line|
        load_arr << line
    end

    load_arr.each do |element|
        element = element.gsub!("\n", "")
    end

    word = load_arr[0]
    blanked_out_word = WordField.new(word)
    $hint = load_arr[1]
    if $hint == 'true'
        $hint = true
    else $hint == 'false'
        $hint = false
    end
    count = load_arr[2].to_i
    load_counter = 3
    mystery_ender = 3 + word.length
    while (load_counter < mystery_ender)
        load_arr_mystery << load_arr[load_counter]
        load_counter += 1
    end
    blanked_out_word.mystery = load_arr_mystery
    while (load_counter < load_arr.length)
        load_arr_junk << load_arr[load_counter]
        load_counter +=1
    end
    my_junk.arr = load_arr_junk
    renderer = 0
    while renderer <= count
        my_grid.draw_hang(renderer, word, blanked_out_word.mystery)
        renderer += 1
    end
end

my_grid.draw
blanked_out_word.draw_mystery
my_junk.draw_bad_letters

while ((count < 7) && (has_saved == false))
    print "Please guess a letter, or enter 'save' to save progress and quit: "
    choice = gets.chomp.downcase
    choice_length = choice.chars.length
    while ((choice.chars.length != 1) || !((("a".."z").include? choice) || (("A".."Z").include? choice)))
        if choice == "save"
            has_saved = true
            break
        end
        puts ""
        puts "That's not a single letter."
        puts "Or that's not a letter at all."
        puts "Or both.  Either way..."
        puts ""
        print "Please guess a single letter, or enter 'save' to save progress and quit: "
        choice = gets.chomp.downcase
    end
    if has_saved
        break
    end
    contains = blanked_out_word.letter_guess(choice)
    if (contains == false)
        my_junk.add_letter(choice)
        count += 1
    end
    if (blanked_out_word.did_win?)
        my_grid.grid[1][4] = "   Whew!  That was a close call, "
        my_grid.grid[2][4] = "   Thanks partner!  I owe ya one! "
        my_grid.grid[2][3] = '| '
        my_grid.grid[3][3] = '  '
        my_grid.grid[3][2] = '  '
        my_grid.grid[4][3] = 'O '
        my_grid.grid[5][3] = "| "
        my_grid.grid[6][3] = '| '
        my_grid.grid[5][2] = " /"
        my_grid.grid[7][2] = ' /'
        my_grid.grid[5][3] = "|\\"
        my_grid.grid[7][3] = " \\"
        my_grid.draw
        blanked_out_word.draw_mystery
        my_junk.draw_bad_letters
        puts "\n\n\n\n\n"
        puts "***************************"
        puts "Congratulations, YOU WON!!!"
        puts "***************************"
        puts "\n\n"
        if (Dir.exists? "output")
            FileUtils.rm_r "./output/saved_stuff.txt"
            Dir.rmdir("output")
        end
        break
    end
    my_grid.draw_hang(count, word, blanked_out_word.mystery)
    my_grid.draw
    blanked_out_word.draw_mystery
    my_junk.draw_bad_letters
    puts "\n\n\n\n\n"
    if (count < 7)
        puts "\n\n\n\n\n"
    end
end

if (has_saved == true)
    puts "Saving activated.  Goodbye!"
    Dir.mkdir("output") unless Dir.exists? "output"
    filename = "output/saved_stuff.txt"

    File.open(filename,'w') do |file|
        file.puts word
        file.puts $hint
        file.puts count
        i = 0
        while i < word.length 
            file.puts blanked_out_word.mystery[i]
            i += 1
        end
        i = 0
        while i < my_junk.arr.length 
            file.puts my_junk.arr[i]
            i += 1
        end

    end
end

if ((blanked_out_word.did_win? == false) && (has_saved == false))
    puts "////////////////////////////////////////////////////////////////"
    puts "You lost and the hanging man died, the word was '#{word}'"
    puts "////////////////////////////////////////////////////////////////"
    puts "\n\n"
    if (Dir.exists? "output")
        FileUtils.rm_r "./output/saved_stuff.txt"
        Dir.rmdir("output")
    end
end