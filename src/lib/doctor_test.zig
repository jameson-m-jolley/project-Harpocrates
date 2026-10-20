/// Test file for the library module.
/// This proves the build/test pipeline works.
const std = @import("std");
const doctor = @import("doctor");

test "doctor check works" {
    // Just verify the module compiles and the test runs
    const result = doctor.doctor_struct;
    // This test passes if we get here
}
EOF