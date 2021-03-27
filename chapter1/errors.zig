const expect = @import("std").testing.expect;

const FileOpenError = error{
  AccessDenied,
  OutOfMemory,
  FileNotFound,
};

const AllocationError = error{OutOfMemory};

test "coerce error from a subset to a superset" {
  const err: FileOpenError = AllocationError.OutOfMemory;
  expect(err == FileOpenError.OutOfMemory);
}

test "error union" {
  const maybe_error: AllocationError!u16 = 10;
  const no_error = maybe_error catch 0;

  expect(@TypeOf(no_error) == u16);
  expect(no_error == 10);
}

fn failingFunction() error{Oops}!void {
  return error.Oops;
}

test "returning an error" {
  failingFunction() catch |err| {
    expect(err == error.Oops);
    return;
  };
}

fn failFn() error{Oops}!i32 {
  try failingFunction();
  return 12;
}

test "try" {
  var v = failFn() catch |err| {
    expect(err == error.Oops);
    return;
  };
  expect(v == 12); //never reached
}

var problems: u32 = 98;

fn failFnCounter() error{Oops}!void {
  errdefer problems += 1;
  try failingFunction();
}

test "errdefer" {
  failFnCounter() catch |err| {
    expect(err == error.Oops);
    expect(problems == 99);
    return;
  };
  expect(problems == 99);
}

fn createFile() !void {
  return error.AccessDenied;
}

test "inferred error set" {
  // type coercion
  const x: error{AccessDenied}!void = createFile();
}

const A = error{ NotDir, PathNotFound };
const B = error{ OutOfMemory, PathNotFoun };
const C = A || B;


