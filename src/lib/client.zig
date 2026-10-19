const email = @import("email.zig");
const friends = @import("friends.zig");
const communities = @import("communities.zig");

const client_build_options: type = struct {};
pub fn gen_zooid_client_struct(comptime build_options: client_build_options) type {
    return struct {
        const build_info: client_build_options = build_options;
        port: u16,
        protocol: email.email_protocol,
        user_email: *const [:0]u8,
        friends: friends.friends_struct,
        communities: communities.communities_struct,

        pub fn init() @This() {
            return .{};
        }

        pub fn deinit(this: *@This()) !void {
            _ = this;
        }
    };
}
pub const client_struct = gen_zooid_client_struct(.{ .default_mail_folder = "Zooid" });
