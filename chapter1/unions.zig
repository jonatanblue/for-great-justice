const expect = @import("std").testing.expect;

const Payload = union {
    int: i64,
    float: f64,
    bool: bool,
};

test "simple union" {
    var payload = Payload{ .int = 1234 };
    //    payload.float = 12.34;  // Fails
}

const Tag = enum { a, b, c };

const Tagged = union(Tag) { a: u8, b: f32, c: bool };

test "switch on tagged union" {
    var value = Tagged{ .b = 1.5 };
    switch (value) {
        .a => |*byte| byte.* += 1,
        .b => |*float| float.* *= 2,
        .c => |*b| b.* = !b.*,
    }
}

const Tagged2 = union(enum) { a: u8, b: f32, c: bool, none };
