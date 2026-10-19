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

pub const doctor = @import("doctor.zig");
pub const friends = @import("friends.zig");
pub const email = @import("email.zig");
pub const channels = @import("channels.zig");
pub const communities = @import("communities.zig");
pub const client = @import("client.zig");
pub const shared_types = @import("shared_types.zig");

// re-export constructed structs at top level

pub const doctor_struct = doctor.doctor_struct;
pub const friends_struct = friends.friends_struct;
pub const email_protocol = email.email_protocol;
pub const voice_channels_struct = channels.voice_channels_struct;
pub const channels_struct = channels.channels_struct;
pub const communities_struct = communities.communities_struct;
pub const client_struct = client.client_struct;
