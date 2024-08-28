@dynamicMemberLookup
public struct Case<Value>: Sendable {
  fileprivate let _embed: @Sendable (Value) -> Any
  fileprivate let _extract: @Sendable (Any) -> Value?
}

extension Case {
  public init<Root>(
    embed: @escaping @Sendable (Value) -> Root,
    extract: @escaping @Sendable (Root) -> Value?
  ) {
    self._embed = embed
    self._extract = { @Sendable in ($0 as? Root).flatMap(extract) }
  }

  public subscript<AppendedValue>(
    dynamicMember keyPath: KeyPath<Value.AllCasePaths, AnyCasePath<Value, AppendedValue>>
    & Sendable
  ) -> Case<AppendedValue>
  where Value: CasePathable {
    Case<AppendedValue>(
      embed: { embed(Value.allCasePaths[keyPath: keyPath].embed($0)) },
      extract: { extract(from: $0).flatMap(Value.allCasePaths[keyPath: keyPath].extract) }
    )
  }

  public func embed(_ value: Value) -> Any {
    self._embed(value)
  }

  public func extract(from root: Any) -> Value? {
    self._extract(root)
  }
}

public typealias CaseKeyPath<Root, Value> = KeyPath<Case<Root>, Case<Value>>
