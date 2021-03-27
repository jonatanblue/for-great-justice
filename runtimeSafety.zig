const expect = @import("std").testing.expect;

test "out of bounds" {
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 1;
    const b = a[index];
}

test "out of bounds, no safety" {
    @setRuntimeSafety(false);
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 5;
    const b = a[index];
}

test "unreachable" {
    const x: i32 = 2;
    const y: u32 = if (x == 2) 5 else unreachable;
}

fn asciiToUpper(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x + 'A' - 'a',
        'A'...'Z' => x,
        else => unreachable,
    };
}

test "unreachable switch" {
    expect(asciiToUpper('a') == 'A');
    expect(asciiToUpper('A') == 'A');
    expect(asciiToUpper('b') == 'B');
}
