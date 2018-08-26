import Foundation

public struct BeadsSequence {
    enum BeadType: UInt8 {
        case skip = 0b0000_0000 // 0
        case u8 = 0b0000_0001 // 1
        case i8 = 0b0000_0010 // 2
        case u16 = 0b0000_0011 // 3
        case i16 = 0b0000_0100 // 4
        case u32 = 0b0000_0101 // 5
        case i32 = 0b0000_0110 // 6
        case f32 = 0b0000_0111 // 7
        case u64 = 0b0000_1000 // 8
        case i64 = 0b0000_1001 // 9
        case f64 = 0b0000_1010 // 10

        case compact_buffer = 0b0000_1101 // 13
        case buffer = 0b0000_1110 // 14
        case _nil = 0b0000_1111 // 15

        static func from(u8: UInt8, first: Bool) -> BeadType? {
            if first {
                return BeadType(rawValue: u8 & 0b0000_1111)
            } else {
                return BeadType(rawValue: u8 >> 4)
            }
        }
    }
    private var buffer: [UInt8] = []
    private var elementCount = 0
    private var typeFlagIndex = 0

    public init() {}

    public mutating func append(_ newElement: UInt8?) {
        let flag = newElement == nil ? BeadType._nil : BeadType.u8
        set(beadType: flag)
        if let newElement = newElement {
            buffer.append(newElement)
        }
    }

    public mutating func append(_ newElement: UInt16?) {
        guard let newElement = newElement else {
            set(beadType: BeadType._nil)
            return
        }
        if let u8 = UInt8(exactly: newElement) {
            set(beadType: BeadType.u8)
            put(int: u8)
            return
        }

        set(beadType: BeadType.u16)
        put(int: newElement)
    }

    public mutating func append(_ newElement: UInt32?) {
        guard let newElement = newElement else {
            set(beadType: BeadType._nil)
            return
        }
        if let u8 = UInt8(exactly: newElement) {
            set(beadType: BeadType.u8)
            put(int: u8)
            return
        }
        if let u16 = UInt16(exactly: newElement) {
            set(beadType: BeadType.u16)
            put(int: u16)
            return
        }

        set(beadType: BeadType.u32)
        put(int: newElement)
    }

    public mutating func append(_ newElement: UInt64?) {
        guard let newElement = newElement else {
            set(beadType: BeadType._nil)
            return
        }
        if let u8 = UInt8(exactly: newElement) {
            set(beadType: BeadType.u8)
            put(int: u8)
            return
        }
        if let u16 = UInt16(exactly: newElement) {
            set(beadType: BeadType.u16)
            put(int: u16)
            return
        }
        if let u32 = UInt32(exactly: newElement) {
            set(beadType: BeadType.u32)
            put(int: u32)
            return
        }

        set(beadType: BeadType.u64)
        put(int: newElement)
    }

    public mutating func append(_ newElement: UInt?) {
        guard let newElement = newElement else {
            set(beadType: BeadType._nil)
            return
        }
        if let u8 = UInt8(exactly: newElement) {
            set(beadType: BeadType.u8)
            put(int: u8)
            return
        }
        if let u16 = UInt16(exactly: newElement) {
            set(beadType: BeadType.u16)
            put(int: u16)
            return
        }
        if let u32 = UInt32(exactly: newElement) {
            set(beadType: BeadType.u32)
            put(int: u32)
            return
        }

        set(beadType: BeadType.u64)
        put(int: newElement)
    }

    public mutating func append(_ newElement: Int8?) {
        let flag = newElement == nil ? BeadType._nil : BeadType.i8
        set(beadType: flag)
        if let newElement = newElement {
            buffer.append(UInt8(bitPattern: newElement))
        }
    }

    public mutating func append(_ newElement: Int16?) {
        guard let newElement = newElement else {
            set(beadType: BeadType._nil)
            return
        }
        if let u16 = UInt16(exactly: newElement) {
            append(u16)
            return
        }
        if let i8 = Int8(exactly: newElement) {
            append(i8)
            return
        }

        set(beadType: BeadType.i16)
        put(int: newElement)
    }

    public mutating func append(_ newElement: Int32?) {
        guard let newElement = newElement else {
            set(beadType: BeadType._nil)
            return
        }

        if let u32 = UInt32(exactly: newElement) {
            append(u32)
            return
        }

        if let i8 = Int8(exactly: newElement) {
            set(beadType: BeadType.i8)
            put(int: i8)
            return
        }

        if let i16 = Int16(exactly: newElement) {
            set(beadType: BeadType.i16)
            put(int: i16)
            return
        }

        set(beadType: BeadType.i32)
        put(int: newElement)
    }

    public mutating func append(_ newElement: Int64?) {
        guard let newElement = newElement else {
            set(beadType: BeadType._nil)
            return
        }

        if let u64 = UInt64(exactly: newElement) {
            append(u64)
            return
        }

        if let i8 = Int8(exactly: newElement) {
            set(beadType: BeadType.i8)
            put(int: i8)
            return
        }

        if let i16 = Int16(exactly: newElement) {
            set(beadType: BeadType.i16)
            put(int: i16)
            return
        }

        if let i32 = Int32(exactly: newElement) {
            set(beadType: BeadType.i32)
            put(int: i32)
            return
        }

        set(beadType: BeadType.i64)
        put(int: newElement)
    }

    public mutating func append(_ newElement: Int?) {
        guard let newElement = newElement else {
            set(beadType: BeadType._nil)
            return
        }

        if let u64 = UInt64(exactly: newElement) {
            append(u64)
            return
        }

        if let i8 = Int8(exactly: newElement) {
            set(beadType: BeadType.i8)
            put(int: i8)
            return
        }

        if let i16 = Int16(exactly: newElement) {
            set(beadType: BeadType.i16)
            put(int: i16)
            return
        }

        if let i32 = Int32(exactly: newElement) {
            set(beadType: BeadType.i32)
            put(int: i32)
            return
        }

        set(beadType: BeadType.i64)
        put(int: newElement)
    }

    public mutating func append(_ newElement: Float32?) {
        guard var newElement = newElement else {
            set(beadType: BeadType._nil)
            return
        }

        if let i32 = Int32(exactly: newElement) {
            append(i32)
            return
        }

        if let u32 = UInt32(exactly: newElement) {
            set(beadType: BeadType.u32)
            put(int: u32)
            return
        }

        set(beadType: BeadType.f32)
        withUnsafeBytes(of: &newElement) {
            buffer.append($0[0])
            buffer.append($0[1])
            buffer.append($0[2])
            buffer.append($0[3])
        }
    }

    public mutating func append(_ newElement: Float64?) {
        guard var newElement = newElement else {
            set(beadType: BeadType._nil)
            return
        }

        if let i64 = Int64(exactly: newElement) {
            append(i64)
            return
        }

        if let u64 = UInt64(exactly: newElement) {
            set(beadType: BeadType.u64)
            put(int: u64)
            return
        }

        if var f32 = Float32(exactly: newElement) {
            set(beadType: BeadType.f32)
            withUnsafeBytes(of: &f32) {
                buffer.append($0[0])
                buffer.append($0[1])
                buffer.append($0[2])
                buffer.append($0[3])
            }
            return
        }

        set(beadType: BeadType.f64)
        withUnsafeBytes(of: &newElement) {
            buffer.append($0[0])
            buffer.append($0[1])
            buffer.append($0[2])
            buffer.append($0[3])
            buffer.append($0[4])
            buffer.append($0[5])
            buffer.append($0[6])
            buffer.append($0[7])
        }
    }

    public mutating func append(_ sequence: BeadsSequence?, withSkip: Bool = true) {
        guard let sequence = sequence else {
            set(beadType: BeadType._nil)
            return
        }
        if elementCount % 2 == 0 {
            self.typeFlagIndex = self.buffer.count + sequence.typeFlagIndex
            self.buffer.append(contentsOf: sequence.buffer)
            self.elementCount += sequence.elementCount
        } else {
            if withSkip {
                set(beadType: BeadType.skip)
                self.typeFlagIndex = self.buffer.count + sequence.typeFlagIndex
                self.buffer.append(contentsOf: sequence.buffer)
                self.elementCount += sequence.elementCount
            } else {
                for e in sequence {
                    self.append(e.double)
                }
            }
        }
    }

    public mutating func append(_ data: Data?) {
        guard let data = data else {
            set(beadType: BeadType._nil)
            return
        }
        set(beadType: BeadType.buffer)
        append(data.count)
        self.buffer.append(contentsOf: data)
    }

    public mutating func appendCompact(_ buffer: UnsafeRawBufferPointer) {
        guard let pointer = buffer.baseAddress else { return }
        appendCompact(Data(bytes: pointer, count: buffer.count))
    }

    public mutating func appendCompact(_ data: Data?) {
        guard let data = data else {
            set(beadType: BeadType._nil)
            return
        }
        set(beadType: BeadType.compact_buffer)
        var compact_data = [UInt8]()
        var flagCursor = 0
        for (index, byte) in data.enumerated() {
            if index % 8 == 0 {
                flagCursor = compact_data.count
                compact_data.append(0)
            }
            if byte != 0 {
                let bitMask = UInt8(1) << UInt8(index % 8)
                compact_data[flagCursor] |= bitMask
                compact_data.append(byte)
            }
        }

        if let size = UInt8(exactly: compact_data.count),
            let count = UInt8(exactly: data.count) {
            set(beadType: BeadType.u8)
            put(int: size)
            put(int: count)
        } else if let size = UInt16(exactly: data.count),
            let count = UInt16(exactly: compact_data.count) {
            set(beadType: BeadType.u16)
            put(int: size)
            put(int: count)
        } else if let size = UInt32(exactly: data.count),
            let count = UInt32(exactly: compact_data.count) {
            set(beadType: BeadType.u32)
            put(int: size)
            put(int: count)
        } else {
            set(beadType: BeadType.u64)
            put(int: UInt64(data.count))
            put(int: UInt64(compact_data.count))
        }
        self.buffer.append(contentsOf: compact_data)
    }

    public var data: Data {
        var data: Data
        if Swift.max(buffer.count, elementCount) <= UInt16.max {
            let sizeInt = 4 + buffer.count
            data = Data(capacity: sizeInt)
            var size = UInt16(sizeInt)
            withUnsafeBytes(of: &size) {
                data.append($0[0])
                data.append($0[1])
            }
            var count = UInt16(elementCount)
            withUnsafeBytes(of: &count) {
                data.append($0[0])
                data.append($0[1])
            }
        } else if Swift.max(buffer.count, elementCount) <= UInt32.max {
            let sizeInt = 8 + buffer.count
            data = Data(capacity: sizeInt)
            var size = UInt32(sizeInt)
            withUnsafeBytes(of: &size) {
                data.append($0[0])
                data.append($0[1])
                data.append($0[2])
                data.append($0[3])
            }
            var count = UInt32(elementCount)
            withUnsafeBytes(of: &count) {
                data.append($0[0])
                data.append($0[1])
                data.append($0[2])
                data.append($0[3])
            }
        } else {
            let sizeInt = 16 + buffer.count
            data = Data(capacity: sizeInt)
            var size = UInt64(sizeInt)
            withUnsafeBytes(of: &size) {
                data.append($0[0])
                data.append($0[1])
                data.append($0[2])
                data.append($0[3])
                data.append($0[4])
                data.append($0[5])
                data.append($0[6])
                data.append($0[7])
            }
            var count = UInt64(elementCount)
            withUnsafeBytes(of: &count) {
                data.append($0[0])
                data.append($0[1])
                data.append($0[2])
                data.append($0[3])
                data.append($0[4])
                data.append($0[5])
                data.append($0[6])
                data.append($0[7])
            }
        }

        data.append(contentsOf: buffer)

        return data
    }

    private mutating func put<U: BinaryInteger>(int: U) {
        var newElement = int
        withUnsafeBytes(of: &newElement) {
            for i in 0..<(int.bitWidth / 8) {
                buffer.append($0[i])
            }
        }
    }

    private mutating func set(beadType: BeadType) {
        let flag = beadType.rawValue
        if elementCount % 2 == 0 {
            typeFlagIndex = buffer.count
            buffer.append(flag)
        } else {
            buffer[typeFlagIndex] = buffer[typeFlagIndex] | (flag << 4)
        }
        elementCount += 1
    }
}

let is32Arch = MemoryLayout<Int>.alignment == 4

extension BeadsSequence {
    public enum Bead {
        case _nil
        case u8(UInt8)
        case i8(Int8)
        case u16(UInt16)
        case i16(Int16)
        case u32(UInt32)
        case i32(Int32)
        case u64(UInt64)
        case i64(Int64)
        case f32(Float32)
        case f64(Float64)
        case buffer(ArraySlice<UInt8>)
        case compact_buffer((Int, ArraySlice<UInt8>))

        public var isNil: Bool {
            switch self {
            case ._nil:
                return true
            default:
                return false
            }
        }

        public var int: Int? {
            switch self {
            case ._nil:
                return nil
            case let .i8(v):
                return Int(v)
            case let .u8(v):
                return Int(v)
            case let .u16(v):
                return Int(v)
            case let .i16(v):
                return Int(v)
            case let .u32(v):
                return v <= Int.max ? Int(v) : nil
            case let .i32(v):
                return Int(v)
            case let .u64(v):
                return v <= Int.max ? Int(v) : nil
            case let .i64(v):
                return is32Arch ? nil : Int(v)
            case .f32, .f64, .buffer, .compact_buffer:
                return nil
            }
        }

        public var int64: Int64? {
            switch self {
            case ._nil:
                return nil
            case let .i8(v):
                return Int64(v)
            case let .u8(v):
                return Int64(v)
            case let .u16(v):
                return Int64(v)
            case let .i16(v):
                return Int64(v)
            case let .u32(v):
                return Int64(v)
            case let .i32(v):
                return Int64(v)
            case let .u64(v):
                return v <= Int64.max ? Int64(v) : nil
            case let .i64(v):
                return v
            case .f32, .f64, .buffer, .compact_buffer:
                return nil
            }
        }

        public var uint64: UInt64? {
            switch self {
            case ._nil:
                return nil
            case let .i8(v):
                return UInt64(exactly: v)
            case let .u8(v):
                return UInt64(exactly: v)
            case let .u16(v):
                return UInt64(exactly: v)
            case let .i16(v):
                return UInt64(exactly: v)
            case let .u32(v):
                return UInt64(exactly: v)
            case let .i32(v):
                return UInt64(exactly: v)
            case let .u64(v):
                return v
            case let .i64(v):
                return UInt64(exactly: v)
            case .f32, .f64, .buffer, .compact_buffer:
                return nil
            }
        }

        fileprivate var uintWithSize: (UInt, UInt8)? {
            switch self {
            case ._nil:
                return nil
            case let .i8(v):
                return (UInt(v), 1)
            case let .u8(v):
                return (UInt(v), 1)
            case let .u16(v):
                return (UInt(v), 2)
            case let .i16(v):
                return (UInt(v), 2)
            case let .u32(v):
                return (UInt(v), 4)
            case let .i32(v):
                return (UInt(v), 4)
            case let .u64(v):
                return (UInt(v), 8)
            case let .i64(v):
                return (UInt(v), 8)
            case .f32, .f64, .buffer, .compact_buffer:
                return nil
            }
        }

        public var double: Double? {
            switch self {
            case ._nil:
                return nil
            case let .i8(v):
                return Double(v)
            case let .u8(v):
                return Double(v)
            case let .u16(v):
                return Double(v)
            case let .i16(v):
                return Double(v)
            case let .u32(v):
                return Double(v)
            case let .i32(v):
                return Double(v)
            case let .u64(v):
                return Double(v)
            case let .i64(v):
                return Double(v)
            case let .f32(v):
                return Double(v)
            case let .f64(v):
                return v
            case .buffer, .compact_buffer:
                return nil
            }
        }

        public var data: Data? {
            switch self {
            case let .buffer(slice):
                return Data(bytes: slice)
            case let .compact_buffer(count, slice):
                var data = Data(capacity: count)
                guard slice.isEmpty == false else { return data }
                var elementIdex = 0
                var cursor = slice.startIndex
                while elementIdex < count && cursor < slice.endIndex {
                    let tag = slice[cursor]
                    cursor += 1
                    for bitIndex in 0..<8 {
                        let bitMask = 1 << bitIndex
                        guard elementIdex < count else { break }

                        if tag & UInt8(bitMask) == 0 {
                            data.append(contentsOf: [0])
                        } else {
                            data.append(contentsOf: [slice[cursor]])
                            cursor += 1
                        }
                        elementIdex += 1
                    }
                }
                return data
            default:
                return nil
            }
        }
    }

    public class BeadsIterator: IteratorProtocol {
        let slice: ArraySlice<UInt8>
        let elementCount: Int
        var currentIndex = 0
        var cursor = 0
        var typeFlag: UInt8 = 0
        var tempBuffer: UnsafeMutableRawPointer = UnsafeMutableRawPointer.allocate(byteCount: 8, alignment: 8)

        init(slice: ArraySlice<UInt8>, elementCount: Int) {
            self.slice = slice
            self.elementCount = elementCount
        }

        deinit {
            tempBuffer.deallocate()
        }

        public func next() -> BeadsSequence.Bead? {
            guard currentIndex < elementCount else {
                return nil
            }

            if currentIndex % 2 == 0 {
                guard slice.count > cursor else {
                    return nil
                }
                typeFlag = slice[cursor]
                cursor += 1
            }

            guard let numberType = BeadType.from(u8: typeFlag, first: currentIndex % 2 == 0) else { return nil }

            let result: Bead

            switch numberType {
            case ._nil:
                result = ._nil

            case .skip:
                currentIndex += 1
                return next()

            case .u8:
                guard slice.count > cursor else {
                    result = ._nil
                    break
                }
                result = Bead.u8(slice[cursor])
                cursor += 1

            case .i8:
                guard slice.count > cursor else {
                    result = ._nil
                    break
                }
                result = Bead.i8(Int8(bitPattern: slice[cursor]))
                cursor += 1

            case .u16:
                if let value: UInt16 = readValue() {
                    result = Bead.u16(value)
                } else {
                    result = ._nil
                }

            case .i16:
                if let value: Int16 = readValue() {
                    result = Bead.i16(value)
                } else {
                    result = ._nil
                }

            case .u32:
                if let value: UInt32 = readValue() {
                    result = Bead.u32(value)
                } else {
                    result = ._nil
                }

            case .i32:
                if let value: Int32 = readValue() {
                    result = Bead.i32(value)
                } else {
                    result = ._nil
                }

            case .u64:
                if let value: UInt64 = readValue() {
                    result = Bead.u64(value)
                } else {
                    result = ._nil
                }

            case .i64:
                if let value: Int64 = readValue() {
                    result = Bead.i64(value)
                } else {
                    result = ._nil
                }

            case .f32:
                if let value: Float32 = readValue() {
                    result = Bead.f32(value)
                } else {
                    result = ._nil
                }

            case .f64:
                if let value: Float64 = readValue() {
                    result = Bead.f64(value)
                } else {
                    result = ._nil
                }

            case .buffer:
                currentIndex += 1
                if let size = next()?.uint64 {
                    let nextCursor = cursor + Int(size)
                    let bufferSlice = slice[cursor..<nextCursor]
                    cursor = nextCursor
                    return .buffer(bufferSlice)
                } else {
                    result = ._nil
                }

            case .compact_buffer:
                currentIndex += 1
                if let size = next()?.uintWithSize {
                    let count: Int
                    if size.1 == 1 {
                        guard let _count: UInt8 = readValue() else {
                            return ._nil
                        }
                        count = Int(_count)
                    } else if size.1 == 2 {
                        guard let _count: UInt16 = readValue() else {
                            return ._nil
                        }
                        count = Int(_count)
                    } else if size.1 == 4 {
                        guard let _count: UInt32 = readValue() else {
                            return ._nil
                        }
                        count = Int(_count)
                    } else {
                        guard let _count: UInt64 = readValue() else {
                            return ._nil
                        }
                        count = Int(_count)
                    }

                    let nextCursor = cursor + Int(size.0)
                    let bufferSlice = slice[cursor..<nextCursor]
                    cursor = nextCursor
                    return .compact_buffer((Int(count), bufferSlice))
                } else {
                    result = ._nil
                }
            }

            currentIndex += 1

            return result
        }

        public typealias Element = Bead

        private func readValue<T: Numeric>() -> T? {
            let typeSize = MemoryLayout<T>.alignment
            guard slice.count > cursor + (typeSize - 1) else {
                return nil
            }

            for i in 0 ..< typeSize {
                tempBuffer.advanced(by: i).storeBytes(of: slice[cursor + i], as: UInt8.self)
            }

            cursor += typeSize

            return tempBuffer.bindMemory(to: T.self, capacity: 1).pointee
        }
    }
}

extension BeadsSequence: Sequence {
    public func makeIterator() -> BeadsSequence.BeadsIterator {
        return BeadsIterator(slice: buffer[0...], elementCount: elementCount)
    }

    public typealias Iterator = BeadsIterator

    public typealias Element = Bead

}

extension BeadsSequence {

    public enum ConversionError: Error {
        case UnexpecetdData
    }

    public static func from(data: Data) throws -> BeadsSequence {
        var result = BeadsSequence()
        func setup<T: UnsignedInteger>(_ type: T.Type) throws {
            let (dataSize, elementCount) = data.withUnsafeBytes { (p: UnsafePointer<T>) in
                (p.pointee, p.advanced(by: 1).pointee)
            }
            guard Int(dataSize) == data.count else {
                throw ConversionError.UnexpecetdData
            }
            result.elementCount = Int(elementCount)
            result.buffer = data.advanced(by: MemoryLayout<T>.alignment * 2).map {$0}
        }
        if data.count <= (UInt16.max >> 1) {
            try setup(UInt16.self)
        } else if data.count <= (UInt32.max >> 1) {
            try setup(UInt32.self)
        } else {
            try setup(UInt64.self)
        }
        return result
    }
}

public protocol BeadsConvertible {
    static func from(sequenceIterator: BeadsSequence.BeadsIterator) -> BeadsSequence.FailableResult<Self>?
    var numberOfBeads: Int { get }
    func toBeads() -> BeadsSequence
}

extension BeadsSequence {

    public enum FailableResult<T> {
        case empty
        case value(T)
        case error(Error)

        public func get() throws -> T? {
            switch self {
            case let .value(v):
                return v
            case .empty:
                return nil
            case let .error(e):
                throw e
            }
        }
    }

    public struct BeadsConvertibleSequence<T: BeadsConvertible>: Sequence, IteratorProtocol {
        public mutating func next() -> FailableResult<T>? {
            return T.from(sequenceIterator: iterator)
        }

        private let iterator: BeadsIterator

        init(iterator: BeadsIterator) {
            self.iterator = iterator
        }
    }

    public func beadsConvertibleSequence<T: BeadsConvertible>(for type: T.Type) -> BeadsConvertibleSequence<T> {
        return BeadsConvertibleSequence<T>(iterator: self.makeIterator())
    }
}
