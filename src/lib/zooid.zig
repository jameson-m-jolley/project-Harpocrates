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

pub const doctor_lib = @import("doctor.zig");
pub const friends_lib = @import("friends.zig");
pub const channels_lib = @import("channels.zig");
pub const communities_lib = @import("communities.zig");
pub const client_lib = @import("client.zig");
pub const system_lib = @import("system.zig");
pub const shared_lib = @import("shared_types.zig");
// this whole thing is the adapter pattern for different parts of the app
// this is dont at compile time so that each of the components can do runtime reflrction
// this is not necessary but it is quite good at making things modular
// we can make interfaces but this works just as well for now
// if we need interfaces i will do so
const options: shared_lib.build_options = .{
    .build_dir = ".zooid",
    .db_file_name = "data.db",
    .version_number = 0.01,
};
pub const friends_type = friends_lib.gen_friends_struct(options);
pub const channels_type = channels_lib.gen_channels_struct(options);
pub const voice_channels_type = channels_lib.gen_channels_struct(options);
pub const communities_type = communities_lib.gen_communities_struct(options);
pub const doctor_type = doctor_lib.gen_doctor_struct(options);
pub const client_type = client_lib.gen_zooid_client_struct(options);
pub const system_type = system_lib.gen_zooid_system_obj(options);

// libs that are used in this
// we are adding the https://github.com/vrischmann/zig-sqlite
// args. https://github.com/muhammad-fiaz/args.zig
// curl https://github.com/jiacai2050/zig-curl
