# Michele Welponer, code written based on Conway's Game of Life.
# Copyright (C) 2023  Michele Welponer

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'io/console'

def printGrid(grid, generation)
    rows, cols = grid.size, grid[0].size
    #puts('rows, cols: ' + rows.to_s + ', ' + cols.to_s)

    puts('Generation ' + generation.to_s + ':')
    puts(rows.to_s + ' ' + cols.to_s)

    for r in 0...rows do
        row = ''
        for c in 0...cols do
            row += grid[r][c]
        end
        puts(row)
    end
end

def getNext(grid, dirs)
    rows, cols = grid.size, grid[0].size
    res = Array.new(rows) { Array.new(cols) { '.' } }

    for r in 0...rows do
        for c in 0...cols do
            # count neighbors
            neighbors = 0
            for dr, dc in dirs
                row, col = r + dr, c + dc
                #puts row.to_s + ' ' + col.to_s
                if row >= 0 and row < rows and col >= 0 and col < cols
                    neighbors += grid[row][col] == '*' ? 1 : 0
                end
            end
            #puts 'neighbors: ' + neighbors.to_s

            # evaluate next
            if grid[r][c] == '*' # is alive
                if neighbors >= 2 and neighbors <= 3
                    res[r][c] = '*'
                end
            else # is dead
                if neighbors == 3
                    res[r][c] = '*'
                end
            end
        end
    end

    return res
end

def getNextInplace(grid, dirs)
    rows, cols = grid.size, grid[0].size

    for r in 0...rows do
        for c in 0...cols do
            # code: keeps track of the previous configuration
            # first next  code
            # .     .     0
            # *     .     1
            # .     *     2
            # *     *     3
            # count neighbors
            neighbors = 0
            for dr, dc in dirs
                row, col = r + dr, c + dc
                #puts row.to_s + ' ' + col.to_s
                if row >= 0 and row < rows and col >= 0 and col < cols
                    if grid[row][col] == '*' or grid[row][col] == '1' or grid[row][col] == '3'
                        neighbors += 1
                    end
                end
            end
            #puts 'neighbors: ' + neighbors.to_s

            # evaluate next inplace
            if grid[r][c] == '1' or grid[r][c] == '*' # cell is alive
                if neighbors >= 2 and neighbors <= 3 # condition to remain alive
                    grid[r][c] = '3' # from 1 to 1, code is 3
                else
                    grid[r][c] = '1' # from 1 to 0, code is 1
                end
            else # cell is dead
                if neighbors == 3 # condition to get alive
                    grid[r][c] = '2' # from 0 to 1, code is 2
                # else condition to remain dead, from 0 to 0, code is already 0
                end
            end
        end
    end

    # convert code to next
    for r in 0...rows do
        for c in 0...cols do
            if grid[r][c] == '1'
                grid[r][c] = '.'
            elsif grid[r][c] != '.'
              grid[r][c] = '*'
            end
        end
    end

    return grid
end

def is_integer(string)
  string.to_i.to_s == string
end

def badFormat()
  puts
  puts 'ERROR: bad input format'
  exit
end

################################################################################
dirs = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1],
  [-1, -1], [-1, 1], [1, -1]]

# puts 'Hello, world!'
# a = Array.new(3) { Array.new(2) { 0 } }
# grid = [[0,0,0,0,1,0,0,0],
#         [0,0,0,0,0,1,0,0],
#         [0,0,0,1,1,1,0,0],
#         [0,0,0,0,0,0,0,0]]

# printGrid(grid, 0)
# #grid = getNext(grid, dirs)
# grid = getNextInplace(grid, dirs)
# printGrid(grid, 1)

# i = 5
# c = '*'
# puts 'i:' + i.size.to_s
# puts 'c:' + c.size.to_s
# exit()

######################################### PARSE FILE ###########################
currentDir = Dir.pwd
# puts currentDir
# puts Dir.exists?(currentDir)
# puts File.exists?(currentDir + "input.txt")

count, rows, cols = 0, 0, 0
grid = nil #NIL
File.foreach(currentDir + "/mike.txt") { |line|
  #puts count.to_s + '. ' + line
  count += 1

  case count
    when 1 then
      puts "header ..OK"
      next
    when 2 then
      rows, cols = line.split(" ")
      # check if rows and cols are valid numbers
      # if this is the case initialize the array
      if not (is_integer(rows) && is_integer(cols))
        badFormat()
      end
      puts "rows: " + rows.to_s + " cols: " + cols.to_s + " ..OK"
      grid = Array.new(rows.to_i) { Array.new(cols.to_i) { "." } }
      next

    else # for all the following lines
      #puts 'size:' + (line.size - 1).to_s
      if line.size - 1 != cols.to_i
        badFormat()
      end
      # fill the array
      for c in 0...cols.to_i do
        #puts "  count - 3:" + (count - 3).to_s
        #puts "  c: " + c.to_s
        if line[c] != '.' and line[c] != '*'
          badFormat()
        end
        grid[count - 3][c] = line[c]
      end
  end
}

######################################### MAIN LOOP ############################
count = 0
loop do
  printGrid(grid, count)
  puts 'press spacebar to continue, escape to exit'

  case $stdin.getch
    when "\s"  then
      #puts 'space'
      grid = getNext(grid, dirs)
      count += 1
    when "\e"  then
      #puts 'escape'
      exit
  end
end
