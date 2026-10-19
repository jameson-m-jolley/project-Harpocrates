const std = @import("std");
const args = @import("args");
const Io = std.Io;

const zooid = @import("libzooid");

pub fn set_up_flags(parser: *args.ArgumentParser) !void {
    try parser.addFlag("login", .{
        .short = 'l',
        .help = "starts the login script",
    });

    try parser.addSubcommand(.{
        .name = "doctor",
        .help = "app health check",
        .args = &[_]args.ArgSpec{
            .{ .name = "url", .positional = true, .required = true },
            .{ .name = "reinstall", .short = 'r', .long = "reinstall" },
        },
    });
}

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    var zooid_doctor = zooid.doctor_struct.init(allocator);

    // Create argument parser
    var parser = try args.ArgumentParser.init(allocator, .{
        .name = "zooid_CLI",
        .version = "0.0.1",
        .description = "Privacy-first messaging layer to replace Discord/Slack: end-to-end encrypted, metadata-minimizing, \npeer-to-peer/federated transports with no centralized hosting or data harvesting for AI training",
    });
    defer parser.deinit();
    try set_up_flags(&parser);

    // Parse command-line arguments from the process init context
    var result = try parser.parseProcess(init);
    defer result.deinit();

    // Use parsed values
    const login = result.getBool("login") orelse false;
    if (login) {
        const res: zooid.shared_types.bool_and_buffer = zooid_doctor.check_if_db_exists(init.io) catch unreachable;
        std.debug.print("asking doctor if db exists...\n", .{});
        if (res.result) {
            std.debug.print("starting login...\n", .{});
        } else {
            std.debug.print("db is not found run doctor reinstall...\n", .{});
        }
    }
}
