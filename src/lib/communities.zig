const channels = @import("channels.zig");
const std = @import("std");
const shared = @import("shared_types.zig");

pub fn gen_communities_struct(comptime build_options: shared.build_options) type {
    _ = build_options;
    return struct {
        pub const errors = error{};
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .allocator = allocator,
            };
        }

        pub fn deinit(this: *@This()) !void {
            _ = this;
        }
    };
}
