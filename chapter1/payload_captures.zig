const expect = @import("std").testing.expect;

test "optional-if" {
    var maybe_num: ?usize = 10;
    if (maybe_num) |n| {
        expect(@TypeOf(n) == usize);
        expect(n == 10);
    } else {
        unreachable;
    }
}

test "error union if" {
    var ent_num: error{UnknownEntity}!u32 = 5;
    if (ent_num) |entity| {
        expect(@TypeOf(entity) == u32);
        expect(entity == 5);
    } else |err| {
        unreachable;
    }
}

test "while optional" {
    var i: ?u32 = 10;
    while (i) |num| : (i.? -= 1) {
        expect(@TypeOf(num) == u32);
        if (num == 1) {
            i = null;
            break;
        }
    }
    expect(i == null);
}

var numbers_left2: u32 = undefined;

fn eventuallyErrorSequence() !u32 {
    return if (numbers_left2 == 0) error.ReachedZero else blk: {
        numbers_left2 -= 1;
        break :blk numbers_left2;
    };
}

test "while error union capture" {
    var sum: u32 = 0;
    numbers_left2 = 3;
    while (eventuallyErrorSequence()) |value| {
        sum += value;
    } else |err| {
        expect(err == error.ReachedZero);
    }
}

test "for capture" {
    const x = [_]i8{ 1, 5, 120, -5 };
    for (x) |v| expect(@TypeOf(v) == i8);
}

// Switch cases on tagged unions
const Info = union(enum) {
    a: u32,
    b: []const u8,
    c,
    d: u32,
};

test "switch capture" {
    var b = Info{ .a = 10 };
    const x = switch (b) {
        .b => |str| blk: {
            expect(@TypeOf(str) == []const u8);
            break :blk 1;
        },
        .c => 2,
        // Same type, so can be in the same group
        .a, .d => |num| blk: {
            expect(@TypeOf(num) == u32);
            break :blk num * 2;
        },
    };
    expect(x == 20);
}

const eql = @import("std").mem.eql; // compares two slices

test "for with pointer capture" {
    var data = [_]u8{ 1, 2, 3 };
    // By using pointer capture we can modify the original value
    // (normal payload capture just takes a copy)
    for (data) |*byte| byte.* += 1;
    expect(eql(u8, &data, &[_]u8{ 2, 3, 4 }));
}
