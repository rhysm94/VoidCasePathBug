import Testing
@testable import VoidCasePathBug

@Test func example() async throws {
  withCasePath(casePath: \.didReceiveValue.success)
}
