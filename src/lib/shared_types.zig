pub const sqlite = @import("sqlite");
const std = @import("std");

pub const platform = enum {
    mac,
    linux,
    windows,
};

pub const email_protocol = enum {
    IMAP,
    POP3,
};

// IO abstraction-------------------------------------------------------------------------------
// this is meant for anything that dose system calls
// you will likely need all of this for most io if not its just pointers so its not much memory
pub const system_call_obj = struct {
    io: ?std.Io = null,
    env_map: *const std.process.Environ.Map,
    writer: ?*std.Io.Writer = null,
    db: ?*sqlite.sqlite3 = null,

    pub fn get_home_dir(self: *const @This()) ![]const u8 {
        return self.env_map.get("HOME") orelse return error.HomeDirNotFound;
    }

    /// this is helper that just uses a jump to jump io if ?*std.Io.Writer is null
    pub fn print(
        self: *const @This(),
        comptime format: []const u8,
        args: anytype,
    ) void {
        // 1. Check if the optional writer is present using payload capture
        if (self.writer) |writer| {
            // 2. Format and print. Since your signature returns `void`,
            // you must explicitly handle or swallow any potential I/O errors.
            writer.print(format, args) catch {};
        }
    }

    pub fn exec(
        self: *const @This(),
        sql: [:0]const u8,
    ) !void {
        if (self.db) |db| {
            var err_msg: [*c]u8 = null;
            const rc = sqlite.sqlite3_exec(db, sql.ptr, null, null, &err_msg);
            if (rc != sqlite.SQLITE_OK) {
                if (err_msg) |msg| {
                    std.debug.print("[sqlite] error: {s}\n", .{std.mem.span(msg)});
                    sqlite.sqlite3_free(msg);
                }
                return error.SqliteExecFailed;
            }
        } else {
            return error.SqliteExecFailed;
        }
    }
};
// IO abstraction-------------------------------------------------------------------------------

pub const build_options: type = struct {
    build_dir: [:0]const u8,
    db_file_name: [:0]const u8,
    version_number: f16,
};

pub fn exec(db: *sqlite.sqlite3, sql: [:0]const u8) !void {
    var err_msg: [*c]u8 = null;
    const rc = sqlite.sqlite3_exec(db, sql.ptr, null, null, &err_msg);
    if (rc != sqlite.SQLITE_OK) {
        if (err_msg) |msg| {
            std.debug.print("[sqlite] error: {s}\n", .{std.mem.span(msg)});
            sqlite.sqlite3_free(msg);
        }
        return error.SqliteExecFailed;
    }
}
