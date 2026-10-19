pub fn result_buffer_generic(T: type) type {
    return struct { result: T, buffer: []u8 };
}

pub const bool_and_buffer = result_buffer_generic(bool);
