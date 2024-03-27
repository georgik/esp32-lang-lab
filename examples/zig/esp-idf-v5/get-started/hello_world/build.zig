const std = @import("std");
const idf = @import("idf");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{
        .whitelist = idf.espressif_targets,
        .default_target = idf.espressif_targets[0],
    });
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "hello",
        .root_source_file = .{ .path = "main/hello.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib.root_module.addImport("esp_idf", idf.idf_wrapped_modules(b));

    const idf_path = std.process.getEnvVarOwned(b.allocator, "IDF_PATH") catch "";
    if (!std.mem.eql(u8, idf_path, "")) {
        try idf.searched_idf_include(b, lib, idf_path);
        try searched_idf_libs(b, lib);
    }
    lib.linkLibC();
    b.installArtifact(lib);
}

fn searched_idf_libs(b: *std.Build, lib: *std.Build.Step.Compile) !void {
    var dir = try std.fs.cwd().openDir("../build", .{
        .iterate = true,
    });
    defer dir.close();
    var walker = try dir.walk(b.allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        const ext = std.fs.path.extension(entry.basename);
        const lib_ext = inline for (&.{".obj"}) |e| {
            if (std.mem.eql(u8, ext, e))
                break true;
        } else false;
        if (lib_ext) {
            const src_path = std.fs.path.dirname(@src().file).?;
            const cwd_path = b.pathJoin(&.{ src_path, "build", b.dupe(entry.path) });
            const lib_file: std.Build.LazyPath = .{ .path = cwd_path };
            lib.addObjectFile(lib_file);
        }
    }
}
