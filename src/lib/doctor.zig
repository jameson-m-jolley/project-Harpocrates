const std = @import("std");
const shared_types = @import("shared_types.zig");
/// generator types
const doctor_build_options: type = struct {
    build_dir: [:0]const u8,
    db_file_name: [:0]const u8,
};

pub fn gen_doctor_struct(comptime build_options: doctor_build_options) type {
    return struct {
        pub const build_info: doctor_build_options = build_options;
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .allocator = allocator,
            };
        }

        pub fn deinit(this: *@This()) !void {
            _ = this;
        }

        pub fn check_if_db_exists(io: std.Io, writer: *std.Io.Writer) bool {
            //#1 look if ~/doctor_build_options.build_dir is on the system
            writer.print("[doctor] looking for the {s} dir\n", .{build_info.build_dir}) catch unreachable;
            var dir = std.Io.Dir.cwd().openDir(io, "my_folder", .{}) catch |err| switch (err) {
                error.FileNotFound => {
                    writer.print("[doctor] The directory does not exist!\n\x00", .{}) catch unreachable;
                    return false;
                },
                error.NotDir => {
                    writer.print("[doctor] The path exists, but it's a file, not a directory!\n\x00", .{}) catch unreachable;
                    return false;
                },
                else => {
                    writer.print("[doctor] I can't tell you what is wrong plz go to https://github.com/jameson-m-jolley/project-zooid and submit a issue and get help\n\x00", .{}) catch unreachable;
                    return false;
                }, // Pass any other unexpected system errors up
            };
            defer dir.close(io);

            //#2 look if ~/.doctor_build_options.build_dir/db_file_name.db is there
            writer.print("[doctor] looking for .db file\n", .{}) catch unreachable;
            const file = dir.openFile(io, build_info.db_file_name, .{}) catch |err| {
                if (err == error.FileNotFound) {
                    writer.print("[doctor] dir exists but DB was removed or never created\n", .{}) catch unreachable;
                    return false;
                } else {
                    writer.print("[doctor] dir exists but I can't tell you what is wrong plz go to https://github.com/jameson-m-jolley/project-zooid and submit a issue and get help\n\x00", .{}) catch unreachable;
                    return false;
                }
            };
            _ = file;

            //#3 validate schema
            writer.print("[doctor] DB was found checking schema \n", .{}) catch unreachable;

            //#4 if all the other work then return true.
            return true;
        }

        pub fn install_zooid(io: std.Io, writer: *std.Io.Writer) !void {
            _ = io;
            _ = writer;

            // find out version

            // init the system files eg ~/build_dir/db_file_name.db

            //curl version into if not pulled from gethub

            // load and install schema

            //
        }
    };
}
