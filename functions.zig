const expect = @import("std").testing.expect;

fn addFive(x: u32) u32 {
  return x + 5;
}

test "function" {
  const y = addFive(0);
  expect(@TypeOf(y) == u32);
  expect(y == 5);
}

fn fibonacci(n: u16) u16 {
  if (n == 0 or n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

test "function recursion" {
  const x = fibonacci(10);
  expect(x == 55);
}

fn stackOverflower(n: u16) u16 {
  if (n > 100) return n;
  return stackOverflower(n*n);
}

test "stack overflow" {
  const x = stackOverflower(2);
  expect(x == 256);
}
