const expect = @import("std").testing.expect;

fn increment(num: *u8) void {
    num.* += 1;
}

test "pointers" {
    var x: u8 = 1;
    increment(&x);
    expect(x == 2);
}

test "naughty pointer" {
    var x: u16 = 0;
    var y: *u8 = @intToPtr(*u8, x);
}

test "const pointers" {
    const x: u8 = 1;
    var y = &x;
    y.* += 1;
}

test "const pointer to var" {
    var x: u8 = 1;
    const y = &x;
    y.* += 1;
    expect(x == 2);
}

test "usize" {
    expect(@sizeOf(usize) == @sizeOf(*u8));
    expect(@sizeOf(isize) == @sizeOf(*u8));
}
