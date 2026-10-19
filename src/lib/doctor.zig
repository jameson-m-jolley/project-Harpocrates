const std = @import("std");
const shared_types = @import("shared_types.zig");

/// generator types
const doctor_build_options: type = struct {
    build_dir: [:0]const u8,
    db_file_name: [:0]const u8,
};
pub fn gen_doctor_struct(comptime build_options: doctor_build_options) type {
    return struct {
        const build_info: doctor_build_options = build_options;
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .allocator = allocator,
            };
        }

        pub fn deinit(this: *@This()) !void {
            _ = this;
        }

        pub fn check_if_db_exists(this: *@This(), io: std.Io) !shared_types.bool_and_buffer {
            var ret: shared_types.bool_and_buffer = .{
                .result = true,
                .buffer = try this.allocator.alloc(u8, 256),
            };
            //#1 look if ~/doctor_build_options.build_dir is on the system
            std.debug.print("[doctor] looking for the {s} dir\n", .{build_info.build_dir});
            var dir = std.Io.Dir.cwd().openDir(io, "my_folder", .{}) catch |err| switch (err) {
                error.FileNotFound => {
                    std.debug.print("[doctor] The directory does not exist!\n", .{});
                    ret.result = false;
                    return ret;
                },
                error.NotDir => {
                    std.debug.print("[doctor] The path exists, but it's a file, not a directory!\n", .{});
                    ret.result = false;
                    return ret;
                },
                else => {
                    std.debug.print("[doctor] I can't tell you what is wrong plz go to https://github.com/jameson-m-jolley/project-zooid and submit a issue and get help\n", .{});
                    ret.result = false;
                    return ret;
                }, // Pass any other unexpected system errors up
            };
            defer dir.close(io);

            //#2 look if ~/.doctor_build_options.build_dir/db_file_name.db is there

            //#3 validate schema

            //#4 if all the other work then return true.
            return ret;
        }
    };
}
pub const doctor_struct = gen_doctor_struct(.{
    .build_dir = ".zooid",
    .db_file_name = "data.db",
});
