//
//  Current Locale.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(Testing)

import Testing

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// Returns `true` if the current locale matches the given one.
public func isCurrentLocale(_ locale: Locale) -> Bool {
    Locale.current == locale
}

extension Trait where Self == Testing.ConditionTrait {
    // MARK: - Locale
    
    /// Test is enabled if the current locale matches the given locale.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabled(ifLocale: /* ... */))
    /// func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    public static func enabled(ifLocale locale: Locale) -> ConditionTrait {
        .enabled(if: isCurrentLocale(locale))
    }
    
    /// Test is enabled if the current locale matches one of the given locales.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabled(ifLocale: [/* ... */]))
    /// func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    public static func enabled(ifLocale locales: [Locale]) -> ConditionTrait {
        .enabled(if: locales.contains(where: { Locale.current == $0 }))
    }

    // MARK: - Locale Identifier
    
    /// Test is enabled if the current locale identifier matches the the given identifiers.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabled(ifLocaleIdentifier: /* ... */))
    /// func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - identifier: A BCP-47 language identifier such as `en_US` or `en-u-nu-thai-ca-buddhist`,
    ///     or an ICU-style identifier such as `en@calendar=buddhist;numbers=thai`.
    public static func enabled(ifLocaleIdentifier identifier: String) -> ConditionTrait {
        .enabled(if: Locale.current == Locale(identifier: identifier))
    }
    
    /// Test is enabled if the current locale identifier matches one of the the given identifiers.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabled(ifLocaleIdentifier: [/* ... */]))
    /// func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - identifiers: A BCP-47 language identifier such as `en_US` or `en-u-nu-thai-ca-buddhist`,
    ///     or an ICU-style identifier such as `en@calendar=buddhist;numbers=thai`.
    public static func enabled(ifLocaleIdentifier identifiers: [String]) -> ConditionTrait {
        .enabled(if: identifiers.contains(where: { Locale.current == Locale(identifier: $0) }))
    }

    // MARK: - Locale Identifier Prefix
    
    /// Test is enabled if the current locale identifier contains the given prefix.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabled(ifLocaleIdentifierHasPrefix: "en"))
    /// func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - prefix: Prefix for a BCP-47 language identifier such as `en_US` or `en-u-nu-thai-ca-buddhist`,
    ///     or an ICU-style identifier such as `en@calendar=buddhist;numbers=thai`.
    public static func enabled(ifLocaleIdentifierHasPrefix prefix: String) -> ConditionTrait {
        .enabled(if:
            Locale.current.identifier == prefix
                || Locale.current.identifier.starts(with: "\(prefix)_")
                || Locale.current.identifier.starts(with: "\(prefix)-")
        )
    }

    /// Test is enabled if the current locale identifier contains any of the given prefixes.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabled(ifLocaleIdentifierHasPrefix: ["en", "fr"]))
    /// func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - prefixes: Prefix for a BCP-47 language identifier such as `en_US` or `en-u-nu-thai-ca-buddhist`,
    ///     or an ICU-style identifier such as `en@calendar=buddhist;numbers=thai`.
    public static func enabled(ifLocaleIdentifierHasPrefix prefixes: [String]) -> ConditionTrait {
        .enabled(if:
            prefixes.contains(where: { prefix in
                (Locale.current.identifier == prefix)
                    || Locale.current.identifier.starts(with: "\(prefix)_")
                    || Locale.current.identifier.starts(with: "\(prefix)-")
            })
        )
    }
    
    // MARK: - Region
    
    /// Test is enabled if the current locale region matches the given region.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabled(ifLocaleRegion: .unitedStates))
    /// func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    public static func enabled(ifLocaleRegion region: Locale.Region) -> ConditionTrait {
        .enabled(if: Locale.current.region == region)
    }
    
    /// Test is enabled if the current locale region matches one of the given regions.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabled(ifLocaleRegion: [.unitedStates, .canada]))
    /// func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    public static func enabled(ifLocaleRegion regions: [Locale.Region]) -> ConditionTrait {
        .enabled(
            if: {
                guard let r = Locale.current.region else { return false }
                return regions.contains(r)
            }()
        )
    }

    // MARK: - Language
    
    /// Test is enabled if the current locale language matches the given language.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabled(ifLocaleLanguage: /* ... */))
    /// func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    public static func enabled(ifLocaleLanguage language: Locale.Language) -> ConditionTrait {
        .enabled(if: Locale.current.language == language)
    }
    
    /// Test is enabled if the current locale language matches one of the given languages.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabled(ifLocaleLanguage: [/* ... */]))
    /// func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    public static func enabled(ifLocaleLanguage languages: [Locale.Language]) -> ConditionTrait {
        .enabled(if: languages.contains(Locale.current.language))
    }
    
    // MARK: - Language Code
    
    /// Test is enabled if the current locale language code matches the given language code.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabled(ifLocaleLanguageCode: .english))
    /// func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    public static func enabled(ifLocaleLanguageCode languageCode: Locale.LanguageCode) -> ConditionTrait {
        .enabled(if: Locale.current.language.languageCode == languageCode)
    }
    
    /// Test is enabled if the current locale language code matches one of the given language codes.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabled(ifLocaleLanguageCode: [.english, .french]))
    /// func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    public static func enabled(ifLocaleLanguageCode languageCodes: [Locale.LanguageCode]) -> ConditionTrait {
        .enabled(
            if: {
                guard let c = Locale.current.language.languageCode else { return false }
                return languageCodes.contains(c)
            }()
        )
    }
}

#endif
