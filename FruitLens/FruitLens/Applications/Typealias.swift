//
//  Typealias.swift
//  FruitLense
//
//  Created by Christoph Weber on 18.05.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//


import Foundation

//typealiases

public typealias EmptyCompletion = () -> Void
public typealias CompletionObject<T> = (_ response: T) -> Void
public typealias CompletionOptionalObject<T> = (_ response: T?) -> Void
public typealias CompletionResponse = (_ response: Result<Void, Error>) -> Void
