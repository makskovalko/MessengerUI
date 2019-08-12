//
//  Functions.swift
//  Messenger
//
//  Created by Maxim Kovalko on 8/11/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

precedencegroup CompositionPrecedence {
    associativity: left
}

infix operator =>: CompositionPrecedence
infix operator |>: CompositionPrecedence

func execute(_ action: () -> Void) { action() }

func map <A, B>(_ a: A, _ f: @escaping (A) -> B) -> B {
    return f(a)
}

func map <A, B, C>(_ f: @escaping (A) -> B,
                   _ g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}

func |> <A, B>(_ a: A, _ f: @escaping (A) -> B) -> B {
    return map(a, f)
}

func |> <A, B, C>(_ f: @escaping (A) -> B,
                   _ g: @escaping (B) -> C) -> (A) -> C {
    return map(f, g)
}

@discardableResult
func performIf(_ condition: Bool) -> (@autoclosure () -> Void) -> () {
    return { action in
        guard condition else { return }
        action()
    }
}

func => (_ condition: Bool, closure: @autoclosure () -> Void) {
    return performIf(condition)(closure)
}
