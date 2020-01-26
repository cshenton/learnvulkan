const std = @import("std");
const panic = std.debug.panic;

// Vulkan, GLFW
usingnamespace @import("c.zig");

// Constants
const width = 800;
const height = 600;

// Variables
var window: ?*GLFWwindow = null;

// Initialise glfw and vulkan, run, and exit
pub fn main() void {
    initWindow();
    initVulkan();
    defer cleanup();

    mainLoop();

}

// Create the glfw window
fn initWindow() void {
    const ok = glfwInit();
    if (ok == 0) {
        panic("Failed to initialise GLFW\n", .{});
    }

    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);

    window = glfwCreateWindow(width, height, "Vulkan", null, null);
}

fn initVulkan() void {

}

// Run the program
fn mainLoop() void {
    while (glfwWindowShouldClose(window) == 0) {
        glfwPollEvents();
    }
}

// Deinit any resources
fn cleanup() void {
    glfwDestroyWindow(window);
    glfwTerminate();
}
