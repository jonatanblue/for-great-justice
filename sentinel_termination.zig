const expect = @import("std").testing.expect;

test "sentinel termination" {
    const terminated = [3:0]u8{ 3, 2, 1 };
    expect(terminated.len == 3);
    expect(@bitCast([4]u8, terminated)[3] == 0); // What the tutorial said
    expect(terminated[3] == 0); // But this seems to work just fine too
}

test "string literal" {
    expect(@TypeOf("hello") == *const [5:0]u8);
}

test "C string" {
    const c_string: [*:0]const u8 = "hello";
    var array: [5]u8 = undefined;

    var i: usize = 0;
    while (c_string[i] != 0) : (i += 1) {
        array[i] = c_string[i];
    }
}

test "coercion" {
    var a: [*:0]u8 = undefined;
    const b: [*]u8 = a;

    var c: [5:0]u8 = undefined;
    const d: [5]u8 = c;

    var e: [:10]f32 = undefined;
    const f = e;
}

test "sentinel terminated slicing" {
    var x = [_:0]u8{255} ** 3;
    const y = x[0..3 :0];
}
