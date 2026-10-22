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
