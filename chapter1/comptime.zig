const expect = @import("std").testing.expect;

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

// Force execution at compile time
test "comptime blocks" {
    var x = comptime fibonacci(10);

    var y = comptime blk: {
        break :blk fibonacci(10);
    };

    // x and y are equivalent
}

test "comptime_int" {
    const a = 12;
    const b = a + 10;

    const c: u4 = a;
    const d: f32 = b;
}

test "branching on types" {
    const a = 5;
    const b: if (a < 10) f32 else i32 = 5;
}

// The function name is PascalCase because it returns a type
fn Matrix(
    comptime T: type,
    comptime width: comptime_int,
    comptime height: comptime_int,
) type {
    return [height][width]T;
}

test "resturning a type" {
    expect(Matrix(f32, 4, 4) == [4][4]f32);
}

fn addSmallInts(comptime T: type, a: T, b: T) T {
    return switch (@typeInfo(T)) {
        .ComptimeInt => a + b,
        .Int => |info| if (info.bits <= 16)
            a + b
        else
            @compileError("ints too large"),
        else => @compileError("only ints accepted"),
    };
}

test "typeinfo switch" {
    const x = addSmallInts(u16, 20, 30);
    expect(@TypeOf(x) == u16);
    expect(x == 50);
}

fn GetBiggerInt(comptime T: type) type {
    // The @Type function creates a type
    return @Type(.{
        // We give it an anonymous struct as input
        .Int = .{
            // And get the required fields from the type we were given
            .bits = @typeInfo(T).Int.bits + 1,
            .signedness = @typeInfo(T).Int.signedness,
        },
    });
}

test "@Type" {
    expect(GetBiggerInt(u8) == u9);
    expect(GetBiggerInt(i31) == i32);
}

// Time to use @This. Feels like JavaScript now
fn Vec(
    comptime count: comptime_int,
    comptime T: type,
) type {
    return struct {
        data: [count]T,
        // I guess we are PascalCasing here again because it is a Type?
        const Self = @This(); // @This gets the innermost struct/union/enum

        fn abs(self: Self) Self {
            var tmp = Self{ .data = undefined };
            for (self.data) |elem, i| {
                tmp.data[i] = if (elem < 0)
                    -elem
                else
                    elem;
            }
            return tmp;
        }

        fn init(data: [count]T) Self {
            return Self{ .data = data };
        }
    };
}

const eql = @import("std").mem.eql; // compares two slices

test "generic vector" {
    const x = Vec(3, f32).init([_]f32{ 10, -10, 5 });
    const y = x.abs();
    expect(eql(f32, &y.data, &[_]f32{ 10, 10, 5 }));
}

fn plusOne(x: anytype) @TypeOf(x) {
    return x + 1;
}

test "inferred function parameter" {
    expect(plusOne(@as(u32, 1)) == 2);
}

test "++" {
    const x: [4]u8 = undefined;
    const y = x[0..];

    const a: [6]u8 = undefined;
    const b = a[0..];

    const new = y ++ b; // Concatenate the arrays
    expect(new.len == 10);
}

test "**" {
    const pattern = [_]u8{ 0xCC, 0xAA };
    const memory = pattern ** 3; // Repeat the array three times
    expect(eql(u8, &memory, &[_]u8{ 0xCC, 0xAA, 0xCC, 0xAA, 0xCC, 0xAA }));
}
