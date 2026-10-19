const std = @import("std");
const args = @import("args");
const Io = std.Io;

const zooid = @import("libzooid");

pub fn set_up_flags(parser: *args.ArgumentParser) !void {
    try parser.addFlag("login", .{
        .short = 'l',
        .help = "starts the login script",
    });

    try parser.addFlag("install", .{
        .short = 'i',
        .help = "installs the software",
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

    const io = init.io;
    // Allocate a buffer on the stack for stdout streaming
    var stdout_buffer: [1024]u8 = undefined;
    // Pass the file instance, io handle, and the output buffer
    var stdout_writer = std.Io.File.stdout().writer(io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

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
        stdout.print("[cli] asking doctor if db exists...\n", .{}) catch unreachable;
        const res: bool = zooid_doctor.check_if_db_exists(init.io, stdout);
        if (res) {
            stdout.print("[cli] starting login...\n", .{}) catch unreachable;
        } else {
            stdout.print("[cli] db is not found run doctor reinstall...\n", .{}) catch unreachable;
        }
    }
    stdout.flush() catch unreachable;
}
