// The Swift Programming Language
// https://docs.swift.org/swift-book

public enum Action: CasePathable {
  case didReceiveValue(Result<Void, any Error>)
  public struct AllCasePaths: Sendable {
    public var didReceiveValue: AnyCasePath<Action, Result<Void, any Error>> {
      ._$embed(Action.didReceiveValue) {
        guard case let .didReceiveValue(v0) = $0 else {
          return nil
        }
        return v0
      }
    }
  }

  public static var allCasePaths: AllCasePaths { AllCasePaths() }
}

public func withCasePath<Value>(
  casePath: CaseKeyPath<Action, Value>
) {
  print(casePath)
}

func test() {
  withCasePath(casePath: \.didReceiveValue.success)
}
