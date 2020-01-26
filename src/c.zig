pub usingnamespace @cImport({
    @cDefine("GLFW_INCLUDE_VULKAN", "");
    @cInclude("GLFW/glfw3.h");
    // @cInclude("stb_image.h");
});

// C importer has trouble with this
pub fn _VK_MAKE_VERSION(major: u32, minor: u32, patch: u32) u32 {
    return ((major << @as(u5, 22)) | (minor << @as(u5, 12))) | patch;
}

pub const _VK_API_VERSION_1_0 = _VK_MAKE_VERSION(1, 0, 0);
