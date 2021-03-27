const expect = @import("std").testing.expect;

test "defer" {
  var x: i16 = 5;
  {
    defer x += 2;
    expect(x == 5);
  }
  expect(x == 7);
}

test "multi defer" {
  var x: f32 = 5;
  {
    defer x += 2;
    defer x /= 2;
  }
  expect(x == 4.5);
  {
    x += 1;
  }
  expect(x == 5.5);
}

