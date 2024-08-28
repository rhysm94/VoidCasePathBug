import Foundation

/// A type-erased case path that supports embedding a value in a root and attempting to extract a
/// root's embedded value.
///
/// This type defines key path-like semantics for enum cases, and is used to derive ``CaseKeyPath``s
/// from types that conform to ``CasePathable``.
@dynamicMemberLookup
public struct AnyCasePath<Root, Value>: Sendable {
  private let _embed: @Sendable (Value) -> Root
  private let _extract: @Sendable (Root) -> Value?

  /// Creates a type-erased case path from a pair of functions.
  ///
  /// - Parameters:
  ///   - embed: A function that always succeeds in embedding a value in a root.
  ///   - extract: A function that can optionally fail in extracting a value from a root.
  public init(
    embed: @escaping @Sendable (Value) -> Root,
    extract: @escaping @Sendable (Root) -> Value?
  ) {
    self._embed = embed
    self._extract = extract
  }

  public static func _$embed(
    _ embed: @escaping (Value) -> Root,
    extract: @escaping @Sendable (Root) -> Value?
  ) -> Self {
    nonisolated(unsafe) let embed = embed
    return Self(embed: { embed($0) }, extract: extract)
  }

  /// Returns a root by embedding a value.
  ///
  /// - Parameter value: A value to embed.
  /// - Returns: A root that embeds `value`.
  public func embed(_ value: Value) -> Root {
    self._embed(value)
  }

  /// Attempts to extract a value from a root.
  ///
  /// - Parameter root: A root to extract from.
  /// - Returns: A value if it can be extracted from the given root, otherwise `nil`.
  public func extract(from root: Root) -> Value? {
    self._extract(root)
  }
}

extension AnyCasePath where Value: CasePathable {
  /// Returns a new case path created by appending the case path at the given key path to this one.
  ///
  /// This subscript is automatically invoked by case key path expressions via dynamic member
  /// lookup, and should not be invoked directly.
  ///
  /// - Parameter keyPath: A key path to a case-pathable case path.
  public subscript<AppendedValue>(
    dynamicMember keyPath: KeyPath<Value.AllCasePaths, AnyCasePath<Value, AppendedValue>>
  ) -> AnyCasePath<Root, AppendedValue> {
    @UncheckedSendable var keyPath = keyPath
    return AnyCasePath<Root, AppendedValue>(
      embed: { [$keyPath] in
        embed(Value.allCasePaths[keyPath: $keyPath.wrappedValue].embed($0))
      },
      extract: { [$keyPath] in
        extract(from: $0).flatMap(
          Value.allCasePaths[keyPath: $keyPath.wrappedValue].extract(from:)
        )
      }
    )
  }
}
