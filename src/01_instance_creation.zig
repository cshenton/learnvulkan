const std = @import("std");
const panic = std.debug.panic;

// Vulkan, GLFW
usingnamespace @import("c.zig");

// Errors
const ApplicationError = error {
    GlfwInitError,
    VkCreateInstanceError,
};

// Constants
const width = 800;
const height = 600;

// Variables
var window: ?*GLFWwindow = null;
var instance: VkInstance = undefined;

// Initialise glfw and vulkan, run, and exit
pub fn main() !void {
    try initWindow();
    try initVulkan();
    defer cleanup();

    mainLoop();

}

// Create the glfw window
fn initWindow() !void {
    const ok = glfwInit();
    if (ok == 0) {
        return ApplicationError.GlfwInitError;
    }

    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);

    window = glfwCreateWindow(width, height, "Vulkan", null, null);
}

fn initVulkan() !void {
    try createInstance();
}

// Run the program
fn mainLoop() void {
    while (glfwWindowShouldClose(window) == 0) {
        glfwPollEvents();
    }
}

// Deinit any resources
fn cleanup() void {
    vkDestroyInstance(instance, null);
    glfwDestroyWindow(window);
    glfwTerminate();
}

// Initialise the vulkan instance
fn createInstance() !void {
    const appInfo = VkApplicationInfo{
        .sType = .VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .pApplicationName = "Hello Triangle",
        .applicationVersion = _VK_MAKE_VERSION(1, 0, 0),
        .pEngineName = "No Engine",
        .engineVersion = _VK_MAKE_VERSION(1, 0, 0),
        .apiVersion = _VK_API_VERSION_1_0,
        .pNext = null,
    };

    var glfwExtensionCount: u32 = undefined;
    const glfwExtensions = glfwGetRequiredInstanceExtensions(&glfwExtensionCount);

    const createInfo = VkInstanceCreateInfo{
        .sType = .VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .pApplicationInfo = &appInfo,
        .enabledExtensionCount = glfwExtensionCount,
        .ppEnabledExtensionNames = glfwExtensions,

        // Defaults
        .enabledLayerCount = 0,
        .pNext = null,
        .flags = 0,
        .ppEnabledLayerNames = 0,
    };

    if (vkCreateInstance(&createInfo, null, &instance) != .VK_SUCCESS) {
        return ApplicationError.VkCreateInstanceError;
    }
}
