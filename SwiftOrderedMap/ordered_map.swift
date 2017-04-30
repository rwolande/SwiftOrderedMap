//rmw_ordered_map.swift

public struct OrderedMap<key: Hashable, value>
{
        private var keys: Array<key> = []
        private var values: Dictionary<key, value> = [:]
        public typealias element = (key: key, value: value)
        
        public init()
        {
        }
        
        public subscript(key: key) -> value?
        {
                get
                {
                        return self.values[key]
                }
                set(new_value)
                {
                        if new_value == nil
                        {
                                self.values.removeValue(forKey: key)
                                do
                                {
                                        self.keys = self.keys.filter{$0 != key}
                                }
                                return
                        }
                        
                        let old_value = self.values.updateValue(new_value!, forKey: key)
                        if old_value == nil
                        {
                                self.keys.append(key)
                        }
                }
        }
        
        public func key_at_index(_ index: Int) -> key?
        {
                if index >= self.count
                {
                        return nil
                }
                else
                {
                        return keys[index]
                }
        }
        
        public func index_for_key(_ key: key) -> Int?
        {
                for (index,k) in self.keys.enumerated()
                {
                        if key == k
                        {
                                return index
                        }
                }
                return nil
        }
        
        public func tuple_at_index(_ index: Int) -> (key: key, value: value)?
        {
                if index >= self.count
                {
                        return nil
                }
                let index = keys[index]
                if let value = values[index]
                {
                        return (index,value)
                }
                return nil
        }
        
        public func value_at_index(_ index: Int) -> value?
        {
                if index >= self.count
                {
                        return nil
                }
                else
                {
                        return values[keys[index]]
                }
        }
        
        public var first: value?
        {
                if let first = keys.first
                {
                        return values[first]
                }
                return nil
        }
        
        public var last: value?
        {
                if let last = keys.last
                {
                        return values[last]
                }
                return nil
        }
        
        public mutating func reverse()
        {
                self.keys = Array(self.keys.reversed())
        }
        
        public mutating func insert(_ key: key, value: value, at_index: Int)
        {
                self.keys.insert(key, at: at_index)
                self.values[key] = value
        }
        
        public mutating func append(_ key: key, value: value)
        {
                self.keys.append(key)
                self.values[key] = value
        }
        
        public mutating func prepend(_ key: key, value: value)
        {
                self.keys.insert(key, at: 0)
                self.values[key] = value
        }
        
        public mutating func removeAll(_ keepCapacity: Bool)
        {
                values.removeAll(keepingCapacity: keepCapacity)
                keys.removeAll(keepingCapacity: keepCapacity)
        }
        
        public var count: Int
        {
                return keys.count
        }
        
        public var description: String
        {
                var result = "\n{\n"
                for i in 0..<self.keys.count
                {
                        let key = self.keys[i]
                        let value = self.values[key] == nil ? "[nil]" : self.values[key].debugDescription
                        result += "[\(i)]: \(key) => \(value)\n"
                        
                }
                result += "}"
                return result
        }
}
