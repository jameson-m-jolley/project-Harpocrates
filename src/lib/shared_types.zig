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
