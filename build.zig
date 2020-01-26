const std = @import("std");
const Builder = std.build.Builder;
const builtin = @import("builtin");

pub fn build(b: *Builder) void {
    // Each tutorial stage, its source file, and description
    const targets = [_]Target{
        .{ .name = "base_code", .src = "src/00_base_code.zig", .description = "Base Code" },
        .{ .name = "instance_creation", .src = "src/01_instance_creation.zig", .description = "Instance Creation" },
    };

    // Build all targets
    for (targets) |target| {
        target.build(b);
    }
}

const Target = struct {
    name: []const u8,
    src: []const u8,
    description: []const u8,

    pub fn build(self: Target, b: *Builder) void {
        var exe = b.addExecutable(self.name, self.src);
        exe.setBuildMode(b.standardReleaseOptions());

        // OS stuff
        exe.linkLibC();
        switch (builtin.os) {
            .windows => {
                exe.linkSystemLibrary("kernel32");
                exe.linkSystemLibrary("user32");
                exe.linkSystemLibrary("shell32");
                exe.linkSystemLibrary("gdi32");

                // Vcpkg Install
                exe.addIncludeDir("C:\\Users\\charlie\\src\\github.com\\Microsoft\\vcpkg\\installed\\x64-windows-static\\include\\");
                exe.addLibPath("C:\\Users\\charlie\\src\\github.com\\Microsoft\\vcpkg\\installed\\x64-windows-static\\lib\\");

                // Vulkan Install
                exe.addIncludeDir("C:\\VulkanSDK\\1.1.130.0\\Include\\");
                exe.addLibPath("C:\\VulkanSDK\\1.1.130.0\\Lib\\");
            },
            else => {},
        }

        // GLFW
        exe.linkSystemLibrary("glfw3");

        // Vulkan
        exe.linkSystemLibrary("vulkan-1");

        // STB
        // exe.addCSourceFile("deps/stb_image/src/stb_image_impl.c", &[_][]const u8{"-std=c99"});
        // exe.addIncludeDir("deps/stb_image/include");

        b.default_step.dependOn(&exe.step);
        b.step(self.name, self.description).dependOn(&exe.run().step);
    }
};