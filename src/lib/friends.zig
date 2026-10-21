const std = @import("std");

const friends_build_options: type = struct {
    encrypt_friends_emails: bool,
};
pub fn gen_friends_struct(comptime build_options: friends_build_options) type {
    return struct {
        pub const build_info: friends_build_options = build_options;
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
