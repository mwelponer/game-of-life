from typing import List
from typing import Optional


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

    # first |  next |  code | when
    #  0        0       0     nei is not 3
    #  1        1       3     nei 2 or 3
    #  0        1       2     nei is 3
    #  1        0       1     nei < 2 or nei > 3

    for r in range(ROWS):
        for c in range(COLS):
            # count neighbors
            neighbors = 0
            for dr, dc in dirs:
                row, col = r + dr, c + dc
                if row in range(ROWS) and col in range(COLS):
                    # we increment nei referring to the first configuration
                    # only for code 1 and 3
                    if grid[row][col] == 1 or grid[row][col] == 3:
                        neighbors += 1

            # we calculate next in-place for each cell r, class
            if grid[r][c]: # we have 1 at first
                # cell survive if nei is 2 or 3
                if 2 <= neighbors <= 3:
                    grid[r][c] = 3 # if it was 1 and remains 1, code is 3
                # if it dies in next
                else:
                    grid[r][c] = 1 # it was 1 and dies, code is 1

            # if at first we have a dead cell
            else:
                # it gets to life if nei is 3
                if neighbors == 3:
                    grid[r][c] = 2 # from 0 at first to 1, code is 2
                # else, i.e. it remains dead, 0 to 0, code is 0

    # second pass to convert code back to live/dead
    for r in range(ROWS):
        for c in range(COLS):
            # 0 -> 0
            # 1 -> 0
            # 2 and 3 -> 1
            if grid[r][c] > 0:
                if grid[r][c] <= 1:
                    grid[r][c] = 0
                else:
                    grid[r][c] = 1

    return grid



#s = Solution()
grid = [[0,0,0,0,1,0,0,0],
        [0,0,0,0,0,1,0,0],
        [0,0,0,1,1,1,0,0],
        [0,0,0,0,0,0,0,0]]

for i in range(20):
    printGrid(grid, i)
    grid = getNext(grid)
