const expect = @import("std").testing.expect;

test "anonymous struct literal" {
    const Point = struct { x: i32, y: i32 };

    var pt: Point = .{
        .x = 13,
        .y = 67,
    };
    expect(pt.x == 13);
    expect(pt.y == 67);
}

test "fully anonymous struct" {
    dump(.{
        .int = @as(u32, 1234),
        .float = @as(f64, 12.34),
        .b = true,
        .s = "hi",
    });
}

fn dump(args: anytype) void {
    expect(args.int == 1234);
    expect(args.float == 12.34);
    expect(args.b);
    expect(args.s[0] == 'h');
    expect(args.s[1] == 'i');
}

// So tuples are just special cases of struct
test "tuple" {
    const values = .{
        @as(u32, 1234),
        @as(f64, 12.34),
        true,
        "hi",
    } ++ .{false} ** 2;
    expect(values[0] == 1234);
    expect(values[4] == false);
    inline for (values) |v, i| {
        if (i != 2) continue;
        expect(v);
    }
    expect(values.len == 6);
    expect(values.@"3"[0] == 'h');
}
