const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //LIB__________________________________________________________________________

    const zooid_module = b.createModule(.{
        .root_source_file = b.path("src/lib/zooid.zig"),
        .target = target,
        .optimize = optimize,
    });

    // we make the whole thing as a shard lib so that Harpocrates becomes a tool as well as a lib that others can estend
    const lib = b.addLibrary(.{
        .name = "zooid",
        .linkage = .dynamic,
        .root_module = zooid_module,
    });
    const sqlite = b.dependency("sqlite", .{
        .target = target,
        .optimize = optimize,
    });
    lib.root_module.addImport("sqlite", sqlite.module("sqlite"));
    b.installArtifact(lib);

    // Creates an executable that will run `test` blocks from the provided module.
    // Here `mod` needs to define a target, which is why earlier we made sure to
    // set the releative field.
    const lib_tests = b.addTest(.{
        .root_module = zooid_module,
    });

    // A run step that will run the test executable.
    const run_lib_tests = b.addRunArtifact(lib_tests);

    // shared deps _________________________________________________________________________________
    const args_dep = b.dependency("args", .{
        .target = target,
        .optimize = optimize,
    });

    const vaxis_dep = b.dependency("vaxis", .{
        .target = target,
        .optimize = optimize,
    });

    // TUI___________________________________________________________________________________________
    const tui = b.addExecutable(.{
        .name = "zooid_tui",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/tui/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "project_zooid", .module = zooid_module },
            },
        }),
    });
    b.installArtifact(tui);
    tui.root_module.addImport("args", args_dep.module("args"));
    tui.root_module.addImport("vaxis", vaxis_dep.module("vaxis"));
    const run_tui_step = b.step("run-tui", "Run the tui app");

    const run_tui = b.addRunArtifact(tui);
    run_tui_step.dependOn(&run_tui.step);

    run_tui.step.dependOn(b.getInstallStep());

    run_tui.addPassthruArgs();
    const tui_tests = b.addTest(.{
        .root_module = tui.root_module,
    });

    const run_tui_tests = b.addRunArtifact(tui_tests);
    // CLI___________________________________________________________________________________________

    const cli = b.addExecutable(.{
        .name = "zooid_cli",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/cli/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "libzooid", .module = zooid_module },
            },
        }),
    });
    b.installArtifact(cli);
    cli.root_module.addImport("args", args_dep.module("args"));
    const run_cli_step = b.step("run-cli", "Run the cli app");

    const run_cli = b.addRunArtifact(cli);
    run_cli_step.dependOn(&run_cli.step);

    run_cli.step.dependOn(b.getInstallStep());

    run_cli.addPassthruArgs();

    const cli_tests = b.addTest(.{
        .root_module = cli.root_module,
    });

    // A run step that will run the second test executable.
    const run_cli_tests = b.addRunArtifact(cli_tests);

    //FULL TEST STEP_________________________________________________________________________________
    // A top level step for running all tests. dependOn can be called multiple
    // times and since the two run steps do not depend on one another, this will
    // make the two of them run in parallel.
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_lib_tests.step);
    test_step.dependOn(&run_tui_tests.step);
    test_step.dependOn(&run_cli_tests.step);
}
