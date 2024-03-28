const std = @import("std");
const builtin = @import("builtin");
const idf = @import("esp_idf");

export fn app_main() callconv(.C) void {
    var heap = idf.heap.HeapCapsAllocator.init(.MALLOC_CAP_DEFAULT);
    var arena = std.heap.ArenaAllocator.init(heap.allocator());
    defer arena.deinit();
    const allocator = arena.allocator();

    log.info("Hello, world from Zig!", .{});

    log.info(
        \\[Zig Info]
        \\* Version: {s}
        \\* Compiler Backend: {s}
        \\
    , .{ builtin.zig_version_string, @tagName(builtin.zig_backend) });

    idf.ESP_LOG(allocator, tag,
        \\[ESP-IDF Info]
        \\* Version: {s}
        \\
    , .{idf.Version.get().toString(allocator)});

    idf.ESP_LOG(allocator, tag,
        \\[Memory Info]
        \\* Total: {d}
        \\* Free: {d}
        \\* Minimum: {d}
        \\
    , .{
        heap.totalSize(),
        heap.freeSize(),
        heap.minimumFreeSize(),
    });

    idf.ESP_LOG(allocator, tag, "Let's have a look at your shiny {s} - {s} system! :)\n\n", .{
        @tagName(builtin.cpu.arch),
        builtin.cpu.model.name,
    });

    if (builtin.mode == .Debug)
        heap.dump();
}

// override the std panic function with idf.panic
pub const panic = idf.panic;
const log = std.log.scoped(.@"esp-idf");
pub const std_options = .{
    .log_level = switch (builtin.mode) {
        .Debug => .debug,
        else => .info,
    },
    // Define logFn to override the std implementation
    .logFn = idf.espLogFn,
};

const tag = "zig-hello";
