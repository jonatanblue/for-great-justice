const expect = @import("std").testing.expect;

test "switch statement" {
  var x: i8 = 10;
  switch (x) {
    -1...1 => {
      x = -x; 
    },
    10, 100 => {
      //special handling of division of signed ints
      x = @divExact(x, 10);
    },
    else => {},
  }
  expect(x == 1);
}

test "switch expression" {
  var x: i8 = 10;
  x = switch (x) {
    -1...1 => -x,
    10, 100 => @divExact(x, 10),
    else => x,
  };
  expect(x == 1);
}


