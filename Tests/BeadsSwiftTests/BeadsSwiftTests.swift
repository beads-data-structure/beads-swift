import XCTest
@testable import BeadsSwift

final class BeadsSwiftTests: XCTestCase {
    let umax16 = Int(UInt16.max)
    let umax32 = Int(UInt32.max)
    let imin16 = Int(Int16.min)
    let imin32 = Int(Int32.min)
    let imin64 = Int(Int64.min)

    func testAppendU8() {
        var sequence = BeadsSequence()
        let values: [UInt8?] = [12, 14, nil, 4, 45, nil, nil, nil]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.toData().map { $0 }, [
            9, 10,
            0b00010001, 12, 14,
            0b00011111, 4,
            0b11110001, 45,
            0b11111111, 0
            ])
    }

    func testAppendU16() {
        var sequence = BeadsSequence()
        let values: [UInt16?] = [12, 14, nil, 400, 450, nil, 0, nil]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.toData().map{ $0 }, [
            11, 8,
            0b00010001, 12, 14,
            0b00111111, 144, 1,
            0b11110011, 194, 1,
            0b11110001, 0
            ])
    }

    func testAppendU32() {
        var sequence = BeadsSequence()
        let values: [UInt32?] = [12, nil, 400, 0, UInt32.max]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.toData().map{ $0 }, [
            11, 5,
            0b11110001, 12,
            0b00010011, 144, 1, 0,
            0b00000101, 255, 255, 255, 255
            ])
    }

    func testAppendU64() {
        var sequence = BeadsSequence()
        let values: [UInt64?] = [12, nil, 400, 0, UInt64(UInt32.max), UInt64.max]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.toData().map{ $0 }, [
            19, 6,
            0b11110001, 12,
            0b00010011, 144, 1, 0,
            0b10000101, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
            ])
    }

    func testAppendUInt() {
        var sequence = BeadsSequence()
        let values: [UInt?] = [12, nil, 400, 0, UInt(UInt32.max), UInt(UInt64.max)]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.toData().map{ $0 }, [
            19, 6,
            0b11110001, 12,
            0b00010011, 144, 1, 0,
            0b10000101, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
            ])
    }

    func testAppendI8() {
        var sequence = BeadsSequence()

        let values: [Int8?] = [-1, 0, nil, -4, 45]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.toData().map{ $0 }, [
            7, 5,
            0b00100010, 255, 0,
            0b00101111, 252,
            0b00000010, 45
            ])
    }

    func testAppendI16() {
        var sequence = BeadsSequence()

        let values: [Int16?] = [-1, 0, nil, 250, -129]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.toData().map{ $0 }, [
            8, 5,
            0b00010010, 255, 0,
            0b00011111, 250,
            0b00000100, 127, 255
            ])
    }

    func testAppendI32() {
        var sequence = BeadsSequence()

        let values: [Int32?] = [-1, 0, nil, 250, -129, Int32(UInt16.max), Int32.min]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.toData().map{ $0 }, [
            15, 7,
            0b00010010, 255, 0,
            0b00011111, 250,
            0b00110100, 127, 255, 255, 255,
            0b00000110, 0, 0, 0, 128
            ])
    }

    func testAppendI64() {
        var sequence = BeadsSequence()

        let values: [Int64?] = [
            -1, 0,
            nil, 250,
            -129, Int64(UInt16.max),
            Int64(Int32.min), Int64(UInt32.max),
            Int64.min, Int64(Int32.max)
        ]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.toData().map{ $0 }, [
            32, 10,
            0b0001_0010, 255, 0,
            0b0001_1111, 250,
            0b0011_0100, 127, 255, 255, 255,
            0b0101_0110, 0, 0, 0, 128, 255, 255, 255, 255,
            0b0101_1001, 0, 0, 0, 0, 0, 0, 0, 128, 255, 255, 255, 127,
            ])
    }

    func testAppendInt() {
        var sequence = BeadsSequence()

        let values: [Int?] = [
            -1, 0,
            nil, 250,
            -129, Int(UInt16.max),
            Int(Int32.min), Int(UInt32.max),
            Int.min, Int(Int32.max)
        ]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.toData().map{ $0 }, [
            32, 10,
            0b0001_0010, 255, 0,
            0b0001_1111, 250,
            0b0011_0100, 127, 255, 255, 255,
            0b0101_0110, 0, 0, 0, 128, 255, 255, 255, 255,
            0b0101_1001, 0, 0, 0, 0, 0, 0, 0, 128, 255, 255, 255, 127,
            ])
    }

    func testAppendF32() {
        var sequence = BeadsSequence()

        let values: [Float32?] = [
            -1, 0,
            nil, 250,
            -129, Float32(UInt16.max),
            Float32(Int32.min), Float32(UInt32.max),
            Float32(Int64.min), Float32(Int32.max)
        ]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.toData().map{ $0 }, [
            28, 10,
            0b0001_0010, 255, 0,
            0b0001_1111, 250,
            0b0011_0100, 127, 255, 255, 255,
            0b0111_0111, 0, 0, 0, 207, 0, 0, 128, 79,
            0b0111_0111, 0, 0, 0, 223, 0, 0, 0, 79
            ])
    }

    func testAppendF64() {
        var sequence = BeadsSequence()

        let values: [Float64?] = [
            -1, 0,
            nil, 250,
            -129, Float64(UInt16.max),
            Float64(Int32.min), Float64(UInt32.max),
            Float64(Int64.min), Float64(Int32.max),
            Float64(Float32.infinity), 1.1
        ]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.toData().map{ $0 }, [
            41, 12,
            tag(.i8, .u8), 255, 0,
            tag(._nil, .u8), 250,
            tag(.i16, .u16), 127, 255, 255, 255,
            tag(.i32, .u32), 0, 0, 0, 128, 255, 255, 255, 255,
            tag(.f32, .u32), 0, 0, 0, 223, 255, 255, 255, 127,
            tag(.f32, .f64), 0, 0, 128, 127, 154, 153, 153, 153, 153, 153, 241, 63
            ])
    }

    func tag(_ b1: BeadsSequence.BeadType, _ b2: BeadsSequence.BeadType) -> UInt8 {
        return b1.rawValue | (b2.rawValue << 4)
    }

    func testAppendData() {
        var sequence = BeadsSequence()
        sequence.append("Max".data(using: .utf8))
        sequence.append("Max".data(using: .utf16))
        sequence.append(7)
        sequence.append("Maxim".data(using: .unicode))

        XCTAssertEqual(sequence.toData().map { $0 }, [
            31, 7,
            0b0001_1110, 3, 77, 97, 120,
            0b0001_1110, 8, 255, 254, 77, 0, 97, 0, 120, 0,
            0b1110_0001, 7,
            0b0000_0001, 12, 255, 254, 77, 0, 97, 0, 120, 0, 105, 0, 109, 0
            ])
    }

    func testAppendCompactData() {
        var sequence = BeadsSequence()
        sequence.appendCompact("Max".data(using: .utf8))
        sequence.appendCompact("Max".data(using: .utf16))
        sequence.append(7)
        sequence.appendCompact("Maxim".data(using: .unicode))

        XCTAssertEqual(sequence.toData().map { $0 }, [
            30, 7,
            0b0001_1101, 4, 3, 7, 77, 97, 120,
            0b0001_1101, 6, 8, 87, 255, 254, 77, 97, 120,
            0b1101_0001, 7,
            0b0000_0001, 9, 12, 87, 255, 254, 77, 97, 120, 5, 105, 109
            ])
    }

    func testAppendCompactDataWithIntArray() {
        var sequence = BeadsSequence()
        [1,2,3,4].withUnsafeBytes {
            sequence.appendCompact($0)
        }

        XCTAssertEqual(sequence.toData().map { $0 }, [
            11, 2,
            0b0001_1101, 8, 32, 1, 1, 1, 2, 1, 3, 1, 4
            ])
    }

    func testAppendLongCompactData() {
        var sequence = BeadsSequence()
        sequence.appendCompact("Max".data(using: .utf8))
        sequence.appendCompact("Max".data(using: .utf16))
        sequence.append(7)
        sequence.appendCompact("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.".data(using: .unicode))

        XCTAssertEqual(sequence.toData().map { $0 }, [
            252, 2, 7, 0,
            0b0001_1101, 4, 3, 7, 77, 97, 120,
            0b0001_1101, 6, 8, 87, 255, 254, 77, 97, 120,
            0b1101_0001, 7,
            0b0000_0011, 160, 4, 229, 2,
            87, 255, 254, 76, 111, 114,
            85, 101, 109, 32, 105,
            85, 112, 115, 117, 109,
            85, 32, 100, 111, 108,
            85, 111, 114, 32, 115,
            85, 105, 116, 32, 97,
            85, 109, 101, 116, 44,
            85, 32, 99, 111, 110,
            85, 115, 101, 116, 101,
            85, 116, 117, 114, 32,
            85, 115, 97, 100, 105,
            85, 112, 115, 99, 105,
            85, 110, 103, 32, 101,
            85, 108, 105, 116, 114,
            85, 44, 32, 115, 101,
            85, 100, 32, 100, 105,
            85, 97, 109, 32, 110,
            85, 111, 110, 117, 109,
            85, 121, 32, 101, 105,
            85, 114, 109, 111, 100,
            85, 32, 116, 101, 109,
            85, 112, 111, 114, 32,
            85, 105, 110, 118, 105,
            85, 100, 117, 110, 116,
            85, 32, 117, 116, 32,
            85, 108, 97, 98, 111,
            85, 114, 101, 32, 101,
            85, 116, 32, 100, 111,
            85, 108, 111, 114, 101,
            85, 32, 109, 97, 103,
            85, 110, 97, 32, 97,
            85, 108, 105, 113, 117,
            85, 121, 97, 109, 32,
            85, 101, 114, 97, 116,
            85, 44, 32, 115, 101,
            85, 100, 32, 100, 105,
            85, 97, 109, 32, 118,
            85, 111, 108, 117, 112,
            85, 116, 117, 97, 46,
            85, 32, 65, 116, 32,
            85, 118, 101, 114, 111,
            85, 32, 101, 111, 115,
            85, 32, 101, 116, 32,
            85, 97, 99, 99, 117,
            85, 115, 97, 109, 32,
            85, 101, 116, 32, 106,
            85, 117, 115, 116, 111,
            85, 32, 100, 117, 111,
            85, 32, 100, 111, 108,
            85, 111, 114, 101, 115,
            85, 32, 101, 116, 32,
            85, 101, 97, 32, 114,
            85, 101, 98, 117, 109,
            85, 46, 32, 83, 116,
            85, 101, 116, 32, 99,
            85, 108, 105, 116, 97,
            85, 32, 107, 97, 115,
            85, 100, 32, 103, 117,
            85, 98, 101, 114, 103,
            85, 114, 101, 110, 44,
            85, 32, 110, 111, 32,
            85, 115, 101, 97, 32,
            85, 116, 97, 107, 105,
            85, 109, 97, 116, 97,
            85, 32, 115, 97, 110,
            85, 99, 116, 117, 115,
            85, 32, 101, 115, 116,
            85, 32, 76, 111, 114,
            85, 101, 109, 32, 105,
            85, 112, 115, 117, 109,
            85, 32, 100, 111, 108,
            85, 111, 114, 32, 115,
            85, 105, 116, 32, 97,
            85, 109, 101, 116, 46,
            85, 32, 76, 111, 114,
            85, 101, 109, 32, 105,
            85, 112, 115, 117, 109,
            85, 32, 100, 111, 108,
            85, 111, 114, 32, 115,
            85, 105, 116, 32, 97, 85, 109, 101, 116, 44, 85, 32, 99, 111, 110, 85, 115, 101, 116, 101, 85, 116, 117, 114, 32, 85, 115, 97, 100, 105, 85, 112, 115, 99, 105, 85, 110, 103, 32, 101, 85, 108, 105, 116, 114, 85, 44, 32, 115, 101, 85, 100, 32, 100, 105, 85, 97, 109, 32, 110, 85, 111, 110, 117, 109, 85, 121, 32, 101, 105, 85, 114, 109, 111, 100, 85, 32, 116, 101, 109, 85, 112, 111, 114, 32, 85, 105, 110, 118, 105, 85, 100, 117, 110, 116, 85, 32, 117, 116, 32, 85, 108, 97, 98, 111, 85, 114, 101, 32, 101, 85, 116, 32, 100, 111, 85, 108, 111, 114, 101, 85, 32, 109, 97, 103, 85, 110, 97, 32, 97, 85, 108, 105, 113, 117, 85, 121, 97, 109, 32, 85, 101, 114, 97, 116, 85, 44, 32, 115, 101, 85, 100, 32, 100, 105, 85, 97, 109, 32, 118, 85, 111, 108, 117, 112, 85, 116, 117, 97, 46, 85, 32, 65, 116, 32, 85, 118, 101, 114, 111, 85, 32, 101, 111, 115, 85, 32, 101, 116, 32, 85, 97, 99, 99, 117, 85, 115, 97, 109, 32, 85, 101, 116, 32, 106, 85, 117, 115, 116, 111, 85, 32, 100, 117, 111, 85, 32, 100, 111, 108, 85, 111, 114, 101, 115, 85, 32, 101, 116, 32, 85, 101, 97, 32, 114, 85, 101, 98, 117, 109, 85, 46, 32, 83, 116, 85, 101, 116, 32, 99, 85, 108, 105, 116, 97, 85, 32, 107, 97, 115, 85, 100, 32, 103, 117, 85, 98, 101, 114, 103, 85, 114, 101, 110, 44, 85, 32, 110, 111, 32, 85, 115, 101, 97, 32, 85, 116, 97, 107, 105, 85, 109, 97, 116, 97, 85, 32, 115, 97, 110, 85, 99, 116, 117, 115, 85, 32, 101, 115, 116, 85, 32, 76, 111, 114, 85, 101, 109, 32, 105, 85, 112, 115, 117, 109, 85, 32, 100, 111, 108, 85, 111, 114, 32, 115, 85, 105, 116, 32, 97, 85, 109, 101, 116, 46
            ])
    }

    func testSequenceU8AndI8ToInt() {
        var sequence = BeadsSequence()

        let values = [
            1, 0, nil, 250, nil, 5, -5, -127
        ]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.map { $0.int }, values)
    }

    func testSequenceU8AndI8ToIntWithNilAndSkip() {
        var sequence = BeadsSequence()

        let values = [
            1, nil, 250
        ]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.map { $0.int }, values)
    }

    func testSequenceU16ToInt() {
        var sequence = BeadsSequence()

        let values = [
            980, 1, 0, nil, 250, umax16, nil, 5, -5, -127, 450, nil
        ]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.map { $0.int }, values)
    }

    func testSequenceI16ToInt() {
        var sequence = BeadsSequence()

        let values = [
            980, 1, 0, nil, 250, umax16, nil, 5, -5, -127, 450, nil, imin16, -4521
        ]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.map { $0.int }, values)
    }

    func testSequenceU32ToInt() {
        var sequence = BeadsSequence()

        let values = [
            980, 1, 0, nil, 250, umax16, nil, 5, -5, -127, 450, nil, imin16, -4521, umax32, 12345678
        ]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.map { $0.int }, values)
    }

    func testSequenceI32ToInt() {
        var sequence = BeadsSequence()

        let values = [
            980, 1, 0, nil, 250, umax16, nil, 5, -5, -127, 450, nil, imin16, -4521, umax32, 12345678, imin32, -765432
        ]
        for v in values {
            sequence.append(v)
        }

        XCTAssertEqual(sequence.map { $0.int }, values)
    }

    func testSequenceU64ToInt() {
        var sequence = BeadsSequence()

        let values = [
            980, 1, 0, nil, 250, umax16, nil, 5, -5, -127, 450, nil, imin16, -4521, umax32, 12345678, imin32, -765432
        ]
        for v in values {
            sequence.append(v)
        }
        sequence.append(UInt64.max)

        let expected = [
            980, 1, 0, nil, 250, umax16, nil, 5, -5, -127, 450, nil, imin16, -4521, umax32, 12345678, imin32, -765432, nil
        ]

        XCTAssertEqual(sequence.map { $0.int }, expected)
    }

    func testSequenceU64ToIntStillRepresentable() {
        var sequence = BeadsSequence()

        let values = [
            980, 1, 0, nil, 250, umax16, nil, 5, -5, -127, 450, nil, imin16, -4521, umax32, 12345678, imin32, -765432
        ]
        for v in values {
            sequence.append(v)
        }
        sequence.append(UInt64.max >> 1)

        let expected = [
            980, 1, 0, nil, 250, umax16, nil, 5, -5, -127, 450, nil, imin16, -4521, umax32, 12345678, imin32, -765432, Int.max
        ]

        XCTAssertEqual(sequence.map { $0.int }, expected)
    }

    func testSequenceI64ToInt() {
        var sequence = BeadsSequence()

        let values = [
            980, 1, 0, nil, 250, umax16, nil, 5, -5, -127, 450, nil, imin16, -4521, umax32, 12345678, imin32, -765432, imin64
        ]
        for v in values {
            sequence.append(v)
        }
        sequence.append(UInt64.max)

        let expected = [
            980, 1, 0, nil, 250, umax16, nil, 5, -5, -127, 450, nil, imin16, -4521, umax32, 12345678, imin32, -765432, imin64, nil
        ]

        XCTAssertEqual(sequence.map { $0.int }, expected)
    }

    func testF32ToInt() {
        var sequence = BeadsSequence()
        sequence.append(5)
        sequence.append(0.5)
        XCTAssertEqual(sequence.map { $0.int }, [5, nil])
    }

    func testF64ToInt() {
        var sequence = BeadsSequence()
        sequence.append(5)
        sequence.append(0.5)
        sequence.append(0.1)
        XCTAssertEqual(sequence.map { $0.int }, [5, nil, nil])
    }

    func testToInt64() {
        var sequence = BeadsSequence()
        sequence.append(0)
        sequence.append(-1)
        sequence.append(1)
        sequence.append(umax16)
        sequence.append(imin16)
        sequence.append(imin32)
        sequence.append(umax32)
        sequence.append(imin64)
        sequence.append(UInt64.max >> 1)
        sequence.append(UInt64.max)
        sequence.append(0.5)
        sequence.append(0.1)
        let i: Int? = nil
        sequence.append(i)
        XCTAssertEqual(sequence.map { $0.int64 }, [
            Int64(0), Int64(-1), Int64(1), Int64(umax16), Int64(imin16), Int64(imin32), Int64(umax32), Int64(imin64), Int64.max, nil, nil, nil, nil
            ])
    }

    func testToUInt64() {
        var sequence = BeadsSequence()
        sequence.append(0)
        sequence.append(-1)
        sequence.append(1)
        sequence.append(umax16)
        sequence.append(imin16)
        sequence.append(imin32)
        sequence.append(umax32)
        sequence.append(imin64)
        sequence.append(UInt64.max >> 1)
        sequence.append(UInt64.max)
        sequence.append(0.5)
        sequence.append(0.1)
        let i: Int? = nil
        sequence.append(i)
        XCTAssertEqual(sequence.map { $0.uint64 }, [
            UInt64(0), nil, UInt64(1), UInt64(umax16), nil, nil, UInt64(umax32), nil, UInt64.max >> 1, UInt64.max, nil, nil, nil
            ])
    }

    func testToDouble() {
        var sequence = BeadsSequence()
        sequence.append(0)
        sequence.append(-1)
        sequence.append(1)
        sequence.append(umax16)
        sequence.append(imin16)
        sequence.append(imin32)
        sequence.append(umax32)
        sequence.append(imin64)
        sequence.append(UInt64.max >> 1)
        sequence.append(UInt64.max)
        sequence.append(0.5)
        sequence.append(0.1)
        let i: Int? = nil
        sequence.append(i)
        XCTAssertEqual(sequence.map { $0.double }, [
            Double(0), Double(-1), Double(1), Double(umax16), Double(imin16), Double(imin32), Double(umax32), Double(imin64), Double(Int64.max), Double(UInt64.max), 0.5, 0.1, nil
            ])
    }

    func testToData() {
        var sequence = BeadsSequence()
        let names = ["Max", "Alex", nil, "Maxim", "👻"]
        for name in names {
            sequence.append(name?.data(using: .utf8))
        }

        XCTAssertEqual(sequence.map { (element) -> String? in
            if let data = element.data {
                return String(bytes: data, encoding: .utf8)
            } else {
                return nil
            }
        }, names)
    }

    func testToCompactData() {
        var sequence = BeadsSequence()
        let names = ["Max", "Alex", nil, "Maxim", "👻"]
        for name in names {
            sequence.appendCompact(name?.data(using: .utf16))
        }

        XCTAssertEqual(sequence.map { (element) -> String? in
            if let data = element.data {
                return String(bytes: data, encoding: .utf16)
            } else {
                return nil
            }
        }, names)
    }

    func testFromData() throws {
        var sequence = BeadsSequence()
        for i in 0...1000 {
            sequence.append(i)
        }
        let data = sequence.toData()

        var s1 = try BeadsSequence.from(data: data)
        XCTAssertEqual(data, s1.toData())
    }

    func testAppendLargeAmountOfItems() {
        var sequence = BeadsSequence()
        let i: Int? = nil
        for _ in 0...UInt16.max {
            sequence.append(i)
        }
        let data = sequence.toData()
        print(data.count)
        XCTAssertEqual(data.count, (Int(UInt16.max) / 2 + 8) + 1 )
        let prefix = data[...8].map{ $0 }
        prefix.withUnsafeBytes{
            XCTAssertEqual(Int($0.bindMemory(to: UInt32.self).baseAddress!.pointee), (Int(UInt16.max) / 2) + 1 )
            XCTAssertEqual(Int($0.bindMemory(to: UInt32.self).baseAddress!.advanced(by: 1).pointee), Int(UInt16.max) + 1)
        }
    }

//    func testAppendVeryLargeAmountOfItems() {
//        var sequence = BeadsSequence()
//        let i: Int? = nil
//        for _ in 0...UInt32.max {
//            sequence.append(i)
//        }
//        let data = sequence.data()
//        print(data.count)
//        XCTAssertEqual(data.count, (Int(UInt32.max) / 2 + 16) + 1 )
//        let prefix = data[...16].map{ $0 }
//        prefix.withUnsafeBytes{
//            XCTAssertEqual(Int($0.bindMemory(to: UInt64.self).baseAddress!.pointee), (Int(UInt32.max) / 2) + 1 )
//            XCTAssertEqual(Int($0.bindMemory(to: UInt64.self).baseAddress!.advanced(by: 1).pointee), Int(UInt32.max) + 1)
//        }
//    }

    func testPerformanceExample() {
        var sequence = BeadsSequence()
        var sum = 0
        self.measure {
            for i in 0...1_000_000 {
                sequence.append(UInt8(i % 255))
            }
            for n in sequence {
                sum += n.int!
            }
        }
        XCTAssertEqual(sum, 6984569350)
    }

    func testPerformanceComaprison() {
        var sequence = [UInt8]()
        var sum = 0
        self.measure {
            for i in 0...1_000_000 {
                sequence.append(UInt8(i % 255))
            }
            for n in sequence {
                sum += Int(n)
            }
        }
        XCTAssertEqual(sum, 6984569350)
    }


    static var allTests = [
        ("testAppendU8", testAppendU8),
    ]
}
