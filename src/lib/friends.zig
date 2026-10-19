const friends_build_options: type = struct {
    encrypt_friends_emails: bool,
};
pub fn gen_friends_struct(comptime build_options: friends_build_options) type {
    return struct {
        const build_info: friends_build_options = build_options;

        pub fn init() @This() {
            return .{};
        }

        pub fn deinit(this: *@This()) !void {
            _ = this;
        }
    };
}
pub const friends_struct = gen_friends_struct(.{});
