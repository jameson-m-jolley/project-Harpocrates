const std = @import("std");

// Although this function looks imperative, it does not perform the build
// directly and instead it mutates the build graph (`b`) that will be then
// executed by an external runner. The functions in `std.Build` implement a DSL
// for defining build steps and express dependencies between them, allowing the
// build runner to parallelize the build automatically (and the cache system to
// know when a step doesn't need to be re-run).
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //LIB__________________________________________________________________________

    const harpo_module = b.createModule(.{
        .root_source_file = b.path("src/lib/Harpocrates.zig"),
        .target = target,
        .optimize = optimize,
    });

    // we make the whole thing as a shard lib so that Harpocrates becomes a tool as well as a lib that others can estend
    const lib = b.addLibrary(.{
        .name = "Harpocrates",
        .linkage = .dynamic,
        .root_module = harpo_module,
    });
    b.installArtifact(lib);

    // Creates an executable that will run `test` blocks from the provided module.
    // Here `mod` needs to define a target, which is why earlier we made sure to
    // set the releative field.
    const lib_tests = b.addTest(.{
        .root_module = harpo_module,
    });

    // A run step that will run the test executable.
    const run_lib_tests = b.addRunArtifact(lib_tests);

    // TUI___________________________________________________________________________________________
    const tui = b.addExecutable(.{
        .name = "project_Harpocrates_tui",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/tui/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "project_Harpocrates", .module = harpo_module },
            },
        }),
    });
    b.installArtifact(tui);
    const run_tui_step = b.step("run-tui", "Run the tui app");
    // This creates a top level step. Top level steps have a name and can be
    // invoked by name when running `zig build` (e.g. `zig build run`).
    // This will evaluate the `run` step rather than the default step.
    // For a top level step to actually do something, it must depend on other
    // steps (e.g. a Run step, as we will see in a moment).

    // This creates a RunArtifact step in the build graph. A RunArtifact step
    // invokes an executable compiled by Zig. Steps will only be executed by the
    // runner if invoked directly by the user (in the case of top level steps)
    // or if another step depends on it, so it's up to you to define when and
    // how this Run step will be executed. In our case we want to run it when
    // the user runs `zig build run`, so we create a dependency link.
    const run_tui = b.addRunArtifact(tui);
    run_tui_step.dependOn(&run_tui.step);

    // By making the run step depend on the default step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    run_tui.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_tui.addArgs(args);
    }

    // Creates an executable that will run `test` blocks from the executable's
    // root module. Note that test executables only test one module at a time,
    // hence why we have to create two separate ones.
    const tui_tests = b.addTest(.{
        .root_module = tui.root_module,
    });

    // A run step that will run the second test executable.
    const run_tui_tests = b.addRunArtifact(tui_tests);
    // CLI___________________________________________________________________________________________

    const cli = b.addExecutable(.{
        .name = "project_Harpocrates_cli",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/cli/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "project_Harpocrates", .module = harpo_module },
            },
        }),
    });
    b.installArtifact(cli);
    const run_cli_step = b.step("run-cli", "Run the cli app");
    // This creates a top level step. Top level steps have a name and can be
    // invoked by name when running `zig build` (e.g. `zig build run`).
    // This will evaluate the `run` step rather than the default step.
    // For a top level step to actually do something, it must depend on other
    // steps (e.g. a Run step, as we will see in a moment).

    // This creates a RunArtifact step in the build graph. A RunArtifact step
    // invokes an executable compiled by Zig. Steps will only be executed by the
    // runner if invoked directly by the user (in the case of top level steps)
    // or if another step depends on it, so it's up to you to define when and
    // how this Run step will be executed. In our case we want to run it when
    // the user runs `zig build run`, so we create a dependency link.
    const run_cli = b.addRunArtifact(cli);
    run_cli_step.dependOn(&run_cli.step);

    // By making the run step depend on the default step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    run_cli.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cli.addArgs(args);
    }

    // Creates an executable that will run `test` blocks from the executable's
    // root module. Note that test executables only test one module at a time,
    // hence why we have to create two separate ones.
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
