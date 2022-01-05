//
//  String Path.swift
//  Small Problems
//
//

import Foundation

// Given a array of Stings, a start String and an end String deterimine if a path exists from the start to the end through the array of strings (start and end need not be part of the array).
// Two strings A, and B can form a path AB if the last character of A and the first character of B are the same.
// ex alfred -> dave

/* Examples
 * Input : (["alfred", "ben", "cindy", "dave", "erin"], start: "ana", end: "noelle")
 * Output : true
 *
 * Input : (["story", "book", "novel", "author", "read"], start: "banana", end: "lime")
 *
 */

func pathToString(_ strings: [String], start: String, end: String) -> Bool {
  
  // set our goal to be the last character in start
  let goal = start.last!
  
  // create a set of characters to use and a set of discarded characters, add the first chacter of end
  var pool = Set<Character>()
  var discarded = Set<Character>()
  pool.insert(end.first!)
  
  // while our pool is not empty
  while !pool.isEmpty {
    
    // check to see if the goal is in the pool
    if (pool.contains(goal)) {
      return true
    }
    
    // remove and discard the chosen character
    let c = pool.remove(pool.first!)!
    discarded.insert(c)
    
    // look through the strings and if they can form a path with the character add their first character to the pool if it has not already been discarded
    for string in strings {
      if string.last! == c && !discarded.contains(string.first!) {
        pool.insert(string.first!)
      }
    }
  }
  
  // Should the pool ever be empty there is no path
  return false
}

