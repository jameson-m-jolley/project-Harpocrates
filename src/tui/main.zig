const std = @import("std");
const args = @import("args");

// ---------------------------------------------------------------------------
// Empty config struct for future extensibility via comptime.
// Pattern is obvious and future-proof: TuiConfig can be extended with fields
// without disturbing the architecture.
// ---------------------------------------------------------------------------
pub const TuiConfig = struct {
};

// ---------------------------------------------------------------------------
// CLI flag setup - minimal flags per requirements.
// ---------------------------------------------------------------------------
pub fn set_up_flags(parser: *args.ArgumentParser) !void {
    try parser.addFlag("verbose", .{
        .short = 'v',
        .help = "Enable verbose output",
    });
    try parser.addOption("doctor", .{
        .short = 'd',
        .help = "dose an app health check",
        .default = "output.txt",
    });
    try parser.addFlag("debug", .{
        .short = 'g',
        .help = "Enable debug mode",
    });
}

// ---------------------------------------------------------------------------
// Main entry point.
// ---------------------------------------------------------------------------
pub fn main(init: std.process.Init) !void {
    var arena = std.heap.ArenaAllocator.init(init.arena.allocator());
    defer arena.deinit();
    const allocator = arena.allocator();

    var parser = try args.ArgumentParser.init(allocator, .{
        .name = "zooid_TUI",
        .version = "zooid_TUI",
    });
    defer parser.deinit();

    try set_up_flags(&parser);

    // Write messages using std.debug.print (most compatible API)
    std.debug.print("zooid_TUI started. Press 'q' to quit.\n", .{});
    std.debug.print("Press any key to echo, 'q' to quit\n", .{});

    // Arena is freed here, ensuring no memory leaks
}

// ---------------------------------------------------------------------------
// TTY helpers - architecture placeholders for libvaxis integration
// ---------------------------------------------------------------------------
fn _ttyl_init() void {}

fn _ttyl_deinit() void {}

fn _ttyl_write_str() void {
    // In full libvaxis integration, this would write to the TTY
    // For now, does nothing - the arena deinit ensures memory safety
}