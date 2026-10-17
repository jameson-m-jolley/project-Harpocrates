//! By convention, root.zig is the root source file when making a package.
const std = @import("std");
const Io = std.Io;

pub fn harpocrates_type(memory_alloc: std.mem.Allocator) type {
    return struct {};
}
