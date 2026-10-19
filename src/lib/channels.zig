const voice_channels_build_options: type = struct {};
pub fn gen_voice_channels_struct(comptime build_options: voice_channels_build_options) type {
    return struct {
        const build_info: voice_channels_build_options = build_options;
        pub fn init() @This() {
            return .{};
        }

        pub fn deinit(this: *@This()) !void {
            _ = this;
        }
    };
}
pub const voice_channels_struct = gen_voice_channels_struct(.{});

const channels_build_options: type = struct {};
pub fn gen_channels_struct(comptime build_options: channels_build_options) type {
    return struct {
        const build_info: channels_build_options = build_options;
        pub fn init() @This() {
            return .{};
        }

        pub fn deinit(this: *@This()) !void {
            _ = this;
        }
    };
}
pub const channels_struct = gen_channels_struct(.{});
