const std = @import("std");
const args = @import("args");
const Io = std.Io;

const Harpocrates = @import("libzooid");

pub fn set_up_flags(parser: *args.ArgumentParser) !void {
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
    const verbose = result.getBool("verbose") orelse false;
    const output = result.getString("output") orelse "output.txt";
    const input = result.getString("input") orelse "unknown";

    if (verbose) {
        std.debug.print("Processing {s} -> {s}\n", .{ input, output });
    }
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    try std.testing.fuzz({}, testOne, .{});
}

fn testOne(context: void, smith: *std.testing.Smith) !void {
    _ = context;
    // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!

    const gpa = std.testing.allocator;
    var list: std.ArrayList(u8) = .empty;
    defer list.deinit(gpa);
    while (!smith.eos()) switch (smith.value(enum { add_data, dup_data })) {
        .add_data => {
            const slice = try list.addManyAsSlice(gpa, smith.value(u4));
            smith.bytes(slice);
        },
        .dup_data => {
            if (list.items.len == 0) continue;
            if (list.items.len > std.math.maxInt(u32)) return error.SkipZigTest;
            const len = smith.valueRangeAtMost(u32, 1, @min(32, list.items.len));
            const off = smith.valueRangeAtMost(u32, 0, @intCast(list.items.len - len));
            try list.appendSlice(gpa, list.items[off..][0..len]);
            try std.testing.expectEqualSlices(
                u8,
                list.items[off..][0..len],
                list.items[list.items.len - len ..],
            );
        },
    };
}
