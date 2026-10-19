const channels = @import("channels.zig");

const communities_build_options: type = struct {};
pub fn gen_communities_struct(comptime build_options: communities_build_options) type {
    return struct {
        const build_info: communities_build_options = build_options;
        channels: channels.channels_struct,
        voice_channels: channels.voice_channels_struct,

        pub fn init() @This() {
            return .{};
        }

        pub fn deinit(this: *@This()) !void {
            _ = this;
        }
    };
}
pub const communities_struct = gen_communities_struct(.{});
