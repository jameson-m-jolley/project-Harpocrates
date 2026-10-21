const email = @import("email.zig");
const friends = @import("friends.zig");
const communities = @import("communities.zig");
const std = @import("std");

const client_build_options: type = struct {
    communities_type: type,
    friends_type: type,
    doctor_type: type,
    email_protocols: type,
};
pub fn gen_zooid_client_struct(comptime build_options: client_build_options) type {
    return struct {
        port: u16,
        protocol: email.email_protocol,
        user_email: ?*const [:0]u8,
        friends: build_options.friends_type,
        communities: build_options.communities_type,
        doctor: build_options.doctor_type,
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .port = 2342,
                .protocol = .IMAP,
                .user_email = null,
                .friends = build_options.friends_type.init(allocator),
                .communities = build_options.communities_type.init(allocator),
                .doctor = build_options.doctor_type.init(allocator),
                .allocator = allocator,
            };
        }

        pub fn deinit(this: *@This()) void {
            _ = this;
        }
    };
}
