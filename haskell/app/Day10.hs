{-# LANGUAGE FlexibleInstances #-}

module Day10 where

import Data.List (find, elemIndex)
import Data.Sequence (index)
import Data.Maybe
import Data.Set (Set)
import qualified Data.Set as Set

-- maze data types

data Dir = North | East | South | West

newtype Maze = Maze [[Char]]

data Pos = Pos Int Int
    deriving (Eq, Show, Ord)

-- maze traversing

at :: Maze -> Pos -> Char
at (Maze maze) (Pos x y) = maze !! y !! x

next :: Pos -> Dir -> Pos
next (Pos x y) North = Pos x (y - 1)
next (Pos x y) East = Pos (x + 1) y
next (Pos x y) South = Pos x (y + 1)
next (Pos x y) West = Pos (x - 1) y

nextDir :: Char -> Dir -> Dir
nextDir 'L' West = North
nextDir 'L' South = East
nextDir 'F' North = East
nextDir 'F' West = South
nextDir 'J' South = West
nextDir 'J' East = North
nextDir '7' East = South
nextDir '7' North = West
nextDir _   dir = dir

class WalkContext a where
    updateContext :: a -> Pos -> a

walk :: WalkContext a => Maze -> Pos -> Pos -> Dir -> a -> a
walk maze startPos pos dir ctx
    | startPos == newPos = updateContext ctx pos
    | otherwise = walk maze startPos newPos newDir (updateContext ctx pos)
    where 
      newPos = next pos dir
      newDir = nextDir (at maze newPos) dir

findStartPos :: Maze -> Int -> Pos
findStartPos (Maze (x:xs)) nLine =
    case elemIndex 'S' x of
        Nothing -> findStartPos (Maze xs) (nLine + 1)
        Just i  -> Pos i nLine

-- part 1

instance WalkContext Int where
    updateContext val _ = val + 1

day10 :: String -> Int
day10 content = loopSize `div` 2
    where
      maze = Maze (lines content)
      startPos = findStartPos maze 0
      loopSize = walk maze startPos startPos South 1

-- part 2

instance WalkContext (Set Pos) where
    updateContext set pos = Set.insert pos set

insideCoef :: Char -> Int
insideCoef ch
    | ch == '|'  = 2
    | ch == '.' = 0
    | ch == 'L' || ch == '7' = -1
    | otherwise = 1

countArea :: String -> Set Pos -> Int -> Pos -> Int
countArea [] _ _ _ = 0
countArea (c:cs) set coef (Pos x y)
    | c /= '-' && isLoop = countArea cs set newCoef newPos
    | not isLoop = area + countArea cs set coef newPos
    | otherwise = countArea cs set coef newPos
    where
      pos = Pos x y
      newPos = Pos (x + 1) y
      isLoop = Set.member pos set
      newCoef = if isLoop 
                    then coef + insideCoef c
                    else coef 
      area = fromEnum (coef `mod` 4 == 2)

day10Part2 :: String -> Int
day10Part2 content = sum $ zipWith (curry countLineArea) contentLines [0..]
    where
      contentLines = lines content
      maze = Maze contentLines
      startPos = findStartPos maze 0
      loopSet = walk maze startPos startPos South Set.empty
      countLineArea (line, nLine) = countArea line loopSet 0 (Pos 0 nLine)

