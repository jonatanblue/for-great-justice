const expect = @import("std").testing.expect;

fn total(values: []const u8) usize {
    var count: usize = 0;
    for (values) |v| count += v;
    return count;
}

test "slices" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..3];
    expect(total(slice) == 6);
}

test "slices 2" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..3];
    expect(@TypeOf(slice) == *const [3]u8);
}

test "slice to the end" {
    var array = [_]u8{ 1, 2, 3, 4, 5 };
    var slice = array[0..];
}
