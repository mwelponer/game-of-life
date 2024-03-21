from typing import List, Optional
from getkey import getkey

#class Solution:
dirs = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, -1], [-1, 1], [1, -1]]

def printGrid(grid: List[List[int]], generation: int):
    rows, cols = len(grid), len(grid[0])
    print('Generation ' +  str(generation) + ':')
    print(rows, cols)
    for r in range(rows):
        row = ''
        for c in range(cols):
            row += ('*' if grid[r][c] else '.')
        print(row)

def getNext(grid: List[List[int]]) -> List[List[int]]:
    ROWS, COLS = len(grid), len(grid[0])
    res = [[0] * COLS for r in range(ROWS)]

    for r in range(ROWS):
        for c in range(COLS):
            # count neighbors
            neighbors = 0
            for dr, dc in dirs:
                row, col = r + dr, c + dc
                if row in range(ROWS) and col in range(COLS):
                    neighbors += grid[row][col]

            if grid[r][c]:
                if 2 <= neighbors <= 3:
                    res[r][c] = 1
            else:
                if neighbors == 3:
                    res[r][c] = 1

    return res

def getNextInplace(grid: List[List[int]]) -> List[List[int]]:
    ROWS, COLS = len(grid), len(grid[0])

    # first next code
    #   0    0     0
    #   1    0     1
    #   0    1     2
    #   1    1     3
    for r in range(ROWS):
        for c in range(COLS):
            # count neighbors
            neighbors = 0
            for dr, dc in dirs:
                row, col = r + dr, c + dc
                if row in range(ROWS) and col in range(COLS):
                    if grid[row][col] == 1 or grid[row][col] == 3:
                        neighbors += 1

            # evaluate next inplace
            if grid[r][c]: # cell is alive
                if 2 <= neighbors <= 3: # condition to remain alive
                    grid[r][c] = 3 # from 1 to 1, code is 3
                else:
                    grid[r][c] = 1 # from 1 to 0, code is 1
            else: # cell is dead
                if neighbors == 3: # condition to get alive
                    grid[r][c] = 2 # from 0 to 1, code is 2
                # else condition to remain dead, from 0 to 0, code is already 0

    # convert code to next
    for r in range(ROWS):
        for c in range(COLS):
            if grid[r][c] == 1:
                grid[r][c] = 0
            elif grid[r][c] != 0:
                grid[r][c] = 1

    return grid



#s = Solution()
grid = [[0,0,0,0,1,0,0,0],
        [0,0,0,0,0,1,0,0],
        [0,0,0,1,1,1,0,0],
        [0,0,0,0,0,0,0,0]]

count = 0
while True:
    printGrid(grid, count)
    print('press spacebar to continue, escape to exit\n')

    key = getkey()

    if ord(key) == 32: # spacebar
        grid = getNextInplace(grid)
        count += 1
        continue
    elif ord(key) == 27: # escape
        break
