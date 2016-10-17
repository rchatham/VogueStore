//
//  Stack.swift
//  VogueStore
//
//  Created by Reid Chatham on 10/17/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import Foundation

class Node<T> {
    var data: T
    var next: Node<T>?
    init(data: T) {
        self.data = data
    }
}

struct Stack<T> {
    var top: Node<T>?
    mutating func push(data: T) {
        let new = Node(data: data)
        new.next = top
        top = new
    }
    mutating func pop() -> T? {
        let pop = top?.data
        top = top?.next
        return pop
    }
}

struct Queue<T> {
    var first: Node<T>?
    var last: Node<T>?
    mutating func enqueue(data: T) {
        let new = Node(data: data)
        if first != nil {
            last?.next = new
        } else {
            first = new
        }
        last = new
    }
    mutating func dequeue() -> T? {
        let next = first?.data
        first = first?.next
        if first == nil {
            last = nil
        }
        return next
    }
}
