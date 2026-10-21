const channels = @import("channels.zig");
const std = @import("std");

const communities_build_options: type = struct {
    voice_channels_type: type,
    channels_type: type,
};
pub fn gen_communities_struct(comptime build_options: communities_build_options) type {
    return struct {
        pub const build_info: communities_build_options = build_options;
        channels: build_info.channels_type,
        voice_channels: build_info.voice_channels_type,
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .allocator = allocator,
                .channels = build_info.channels_type.init(allocator),
                .voice_channels = build_info.voice_channels_type.init(allocator),
            };
        }

        pub fn deinit(this: *@This()) !void {
            _ = this;
        }
    };
}
