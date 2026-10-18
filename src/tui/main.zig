const std = @import("std");
const args = @import("args");
const Io = std.Io;
const Harpocrates = @import("libzooid");
pub fn set_up_flags(parser: *args.ArgumentParser) !void {

    // Add arguments
    try parser.addFlag("verbose", .{
        .short = 'v',
        .help = "Enable verbose output",
    });

    try parser.addOption("doctor", .{
        .short = 'd',
        .help = "dose an app health check",
        .default = "output.txt",
    });
}

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();

    // Create argument parser
    var parser = try args.ArgumentParser.init(allocator, .{
        .name = "zooid_TUI",
        .version = "0.0.1",
        .description = "Privacy-first messaging layer to replace Discord/Slack: end-to-end encrypted, metadata-minimizing, \npeer-to-peer/federated transports with no centralized hosting or data harvesting for AI training",
    });
    defer parser.deinit();
    try set_up_flags(&parser);

    // Parse command-line arguments from the process init context
    var result = try parser.parseProcess(init);
    defer result.deinit();
}
