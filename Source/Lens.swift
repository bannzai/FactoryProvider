//
//  Lens.swift
//  FactoryProvider
//
//  Created by Ihara Takeshi on 2018/06/11.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Foundation

infix operator *~: MultiplicationPrecedence
infix operator |>: AdditionPrecedence

public struct Lens<A, B> {
    private let getter: (A) -> B
    private let setter: (B, A) -> A

    public init(getter: @escaping (A) -> B, setter: @escaping (B, A) -> A) {
        self.getter = getter
        self.setter = setter
    }

    public func get(_ from: A) -> B {
        return getter(from)
    }

    public func set(_ from: B, _ to: A) -> A {
        return setter(from, to)
    }
}

public func * <A, B, C> (lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    return Lens<A, C>(
        getter: { a in
            rhs.get(lhs.get(a))
        },
        setter: { (c, a) in
            lhs.set(rhs.set(c, lhs.get(a)), a)
        }
    )
}

public func *~ <A, B> (lhs: Lens<A, B>, rhs: B) -> (A) -> A {
    return { a in
        lhs.set(rhs, a)
    }
}

public func |> <A, B> (x: A, f: (A) -> B) -> B {
    return f(x)
}

public func |> <A, B, C> (f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}
