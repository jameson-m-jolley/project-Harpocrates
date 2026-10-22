const std = @import("std");
const shared = @import("shared_types.zig");
pub const sqlite = @import("sqlite");

pub const doctor_errors = error{};
pub fn gen_doctor_struct(comptime build_options: shared.build_options) type {
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

        pub fn check_if_db_exists(io: std.Io, writer: *std.Io.Writer) bool {
            //#1 look if ~/doctor_build_options.build_dir is on the system
            writer.print("[doctor] looking for the {s} dir\n", .{build_options.build_dir}) catch unreachable;
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
            const file = dir.openFile(io, build_options.db_file_name, .{}) catch |err| {
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

        pub fn install_zooid(io: std.Io, env_map: *const std.process.Environ.Map, writer: *std.Io.Writer) !void {
            // find out version

            writer.print("[doctor] creating ~/{s}/{s} dir\n", .{ build_options.build_dir, build_options.db_file_name }) catch unreachable;

            const home_path = env_map.get("HOME") orelse return error.HomeDirNotFound;

            var home_dir = try std.Io.Dir.cwd().openDir(io, home_path, .{});
            defer home_dir.close(io);

            var config_dir = try home_dir.createDirPathOpen(io, build_options.build_dir, .{});
            defer config_dir.close(io);

            // Create the file inside config_dir
            var db_file = try config_dir.createFile(io, build_options.db_file_name, .{});

            defer db_file.close(io);
            // curl version into if not pulled from github

            // load and install schema
        }
    };
}
