// The Swift Programming Language
// https://docs.swift.org/swift-book

import CasePaths

@CasePathable
public enum Action {
  case didSucceed(Result<Void, any Error>)
  case didReceiveValue(Result<Int, any Error>)

  static let bug = \Action.Cases.didSucceed.success
  static let notBug = \Action.Cases.didReceiveValue.success
}
