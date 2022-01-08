//
//  Redundant Connection II.swift
//
//  Description of the problem
//  https://leetcode.com/problems/redundant-connection-ii/
//

import Foundation

/* Basic description of the solution
 *
 * Find the root node of the tree if it still exists (The extra added edge does not lead to the root)
 * If the root node exists then there exists a node with two parents, and we need to remove one of the parent edges. We can easily find this node, then traverse up the graph from the two parent node following both parent edges. If one of them leads back to two parent node, we can remove it as it results in a cycle. If both lead back to the root node then remove the edge that appears second in the list of edges.
 *
 * If no root node exists then a cycle exists so we can find a leaf node and traverse up the graph to find a cycle. Once the cycle has been found simply remove the edge of the cycle that comes last in the list of edges. If no leaf node can be found then the entire graph is a cycle, so we can remove the edge of the cycle that comes last in the list of edges.
 *
 */

func findRedundantDirectedConnection(_ edges: [[Int]]) -> [Int] {

  // Find n, the number of nodes
  var n = 0
  for edge in edges {
    n = max(edge[0], n, edge[1])
  }
  
  // Find if the root node exists
  var nodes = Set(1...n)
  var twoParentNode = 0
  
  for edge in edges {
    // remove any node that has a edge pointing to it
    if nil == nodes.remove(edge[1]) {
      twoParentNode = edge[1]
    }
  }
  
  // If the root node exists
  if let root = nodes.first {
        
    // Get the two possible removable edges
    var removableEdges = [[Int]]()
    for edge in edges {
      if edge[1] == twoParentNode {
        removableEdges.append(edge)
      }
    }
    
    // Traverse up the graph from the two parent node
    for possibleEdge in removableEdges {
      nodes.removeAll()
      nodes.insert(twoParentNode)
      nodes.insert(possibleEdge[0])
      
      var currentNode = possibleEdge[0]
      var found = currentNode == root || currentNode == twoParentNode
      
      while !found {
        for edge in edges {
          if currentNode == edge[1] {
            // update the current node and check to see if it leads to the root
            found = !nodes.insert(edge[0]).inserted || edge[0] == root
            currentNode = edge[0]
            
            if found {
              break
            }
          }
        }
      }
      
      // If the edge back to the two parent node resulting in a cycle
      if currentNode != root {
        return possibleEdge
      }
    }
    
    // Both edges lead back to the root so remove the second
    return removableEdges[1]
    
  }
  // If no root node exists
  else {
    // Determine if a leaf node exists
    nodes = Set(1...n)
    
    for edge in edges {
      nodes.remove(edge[0])
    }
    
    // If a leaf exists
    if let leaf = nodes.first {
      // find the cycle by traversing up from the leaf
      nodes.removeAll()
      nodes.insert(leaf)
      var currentNode = leaf
      
      var branch = [[Int]]()
      
      var found = false
      
      // While a cycle has not been found
      while !found {
        for edge in edges {
          if currentNode == edge[1] {
            // update the current node and add the edge
            found = !nodes.insert(edge[0]).inserted
            
            currentNode = edge[0]
            branch.append(edge)
            
            if found {
              break
            }
          }
        }
      }
      
      // remove the edges which are not part of the cycle
      let node = branch.last![0]
      var index = 0
      for i in 0...(branch.count-1) {
        if branch[i][1] == node {
          index = i
          break
        }
      }
      
      let cycle = branch.suffix(branch.count - index)
      
      // return the last edge in the cycle
      for edge in edges.reversed() {
        if cycle.contains(edge) {
          return edge
        }
      }
      
      
    }
    // If no leaf exists remove the last edge
    else {
      return edges[n-1]
    }
  }

  // If this is reached then the graph did not have an extra edge
  return []
}
