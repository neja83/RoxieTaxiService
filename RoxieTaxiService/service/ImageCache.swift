//
//  ImageCache.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 27.03.2022.
//

import Foundation

protocol Cache {
    
    associatedtype Value
    associatedtype Key
    
    /**
     Inserting a cached object of type Value
     */
    func insert(_ value: Value, forKey key: Key)
    
    /**
     Return cached object of type Value
     */
    func value(forKey key: Key) -> Value?
    
    /**
     Delete cached object of type Value from cashe by Key
     */
    func removeValue(forKey key: Key)
}

final class ImageCache<Key: Hashable, Value> : Cache {
    
    // MARK: - privates
    private let wrapped = NSCache<WrappedKey, Entry>()
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    
    // MARK: - init
    init(dateProvider: @escaping () -> Date = Date.init, entryLifetime: TimeInterval = 10 * 60) {
        
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
        
    }
    
    // MARK: - methods
    func insert(_ value: Value, forKey key: Key) {
        
        let date = dateProvider().addingTimeInterval(entryLifetime)
        let entry = Entry(value: value, expirationDate: date)
        
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }

    func value(forKey key: Key) -> Value? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }

        guard dateProvider() < entry.expirationDate else {
            // Discard values that have expired
            removeValue(forKey: key)
            return nil
        }

        return entry.value
    }

    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

private extension ImageCache {
    
    /**
     Wrap  public-facing Key values in order to make them NSCache compatible.
     */
    final class WrappedKey: NSObject {
        
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return value.key == key
        }
    }
}

private extension ImageCache {
    
    /**
     Stored target object of class Value
     */
    final class Entry {
        
        let value: Value
        let expirationDate: Date

        init(value: Value, expirationDate: Date) {
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}

extension Cache {
    
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
    
}
