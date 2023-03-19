//
//  main.swift
//  LetUsGo
//
//  Created by kjs on 16/03/23.
//

import Foundation
import Combine

// MARK: - Compose ~
let square = { (number: Int) -> Int in
    return number * number
}

let double = { (number: Int) -> Int in
    return 2 * number
}

print(square(double(2)))
// MARK: ~ Compose



// MARK: - Currying ~
@discardableResult // 스크린샷찍는데 경고없앨려고 넣은것
func add(_ first: Int) -> ((Int) -> Int) {
    let resultFunction = { second in
        return first + second
    }
    return resultFunction
}

add(3)(5)

func curry<First, Last, Output>(
    _ action: @escaping (First, Last) -> Output
) -> ((First) -> ((Last) -> Output)) {
    return { (_ first: First) -> ((Last) -> Output) in
        return { (last: Last) -> Output in
            return action(first, last)
        }
    }
}

func plus(_ lhs: Int, _ rhs: Int) -> Int {
    return lhs + rhs
}

func minus(_ lhs: Int, _ rhs: Int) -> Int {
    return lhs - rhs
}

print(curry(plus)(0)(10)) //10
print(curry(minus)(0)(10)) //-10
// MARK: ~ Currying



// MARK: - Combine ~
struct Food: Decodable {
    let name: String
    let price: Int
    let description: String
}
let dummyData = [
"""
{
    "name":"김치찌개",
    "price":8000,
    "description":"돼지고기냐 참치냐 그것이 문제로다"
}
""",
"""
{
    "name":"떡만두국",
    "price":8000,
    "description":"만두 만두만두 만두"
}
""",
"""
{
    "name":"컵라면",
    "price":1000,
    "description":"다이어트할때 더 생각남"
}
""",
"""
{
    "name":"스팸",
    "price":3500,
    "description":"햇반에 김치"
}
""",
"""
{
    "name":"육개장",
    "price":10000,
    "description":"밥은 무한리필"
}
"""
]

let input = PassthroughSubject<Data, Error>()

let output = input
    .decode(type: Food.self, decoder: JSONDecoder())
    .map(\.name)
    .map { "음식 이름: \($0)" }
    .sink { completionReason in
        print(completionReason)
    } receiveValue: { result in
        print(result)
    }

let timer = Timer.publish(every: 1, on: .current, in: .common)
    .autoconnect()
    .sink { eachTime in
        input.send(dummyData[.random(in: .zero..<dummyData.count)].data(using: .utf8)!)
    }

// MARK: ~ Combine



RunLoop.main.run() // 런루프가 안돌아가면 앱이 끝나서... 콤바인 찍어보려고 넣엇습니다
