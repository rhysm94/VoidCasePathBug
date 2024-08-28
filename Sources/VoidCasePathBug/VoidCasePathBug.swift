// The Swift Programming Language
// https://docs.swift.org/swift-book

import CasePaths

@CasePathable
public enum Action {
  case didReceiveValue(Result<Void, any Error>)
}

public func withCasePath<Value>(
  casePath: CaseKeyPath<Action, Value>
) {
  print(casePath)
}

