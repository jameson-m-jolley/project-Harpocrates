//! By convention, root.zig is the root source file when making a package.
const std = @import("std");
const Io = std.Io;

// we need to bring in IMAP protocol using lib CURL
// we also need encryption

// we will use XML as our protocol for the in email metadata
// we also need to use a huffman encoding scheme to reduce
// the data we send over email

// pipeline is as fallows
// auth
// -> fetch email info
// -> if rooms found
// -> cash on client (30 day evection or on delete/block)
// -> grab room
// -> auth to room with password
// -> decompress info

// so we need a few abstractions
// users
// fiends
// communities
// channels
// chat rooms

// options to look into if we go full xml path
// we can use 1. SaxonC (By Saxonica) to get a full xquery implementation if needed
//

/// generator types
const doctor_build_options: type = struct {};
pub fn gen_doctor_struct(comptime build_options: doctor_build_options) type {
    _ = build_options;
    return struct {};
}
const doctor = gen_doctor_struct(.{});

const friends_build_options: type = struct {};
pub fn gen_friends_struct(comptime build_options: friends_build_options) type {
    _ = build_options;
    return struct {};
}

const client_build_options: type = struct {};
pub fn gen_zooid_client_struct(comptime build_options: client_build_options) type {
    _ = build_options;
    return struct {
        friends: gen_friends_struct(.{}),
    };
}
const client = gen_zooid_client_struct(.{});
