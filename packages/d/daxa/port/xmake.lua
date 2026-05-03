set_project("daxa")
set_version("3.4")

set_languages("cxx20")

add_rules("mode.debug", "mode.release")

option("utils_task_graph")
    set_default(false)
option_end()

option("utils_mem")
    set_default(false)
option_end()

option("utils_imgui")
    set_default(false)
option_end()

option("utils_fsr3")
    set_default(false)
option_end()

option("utils_pipeline_manager_glslang")
    set_default(false)
option_end()

option("utils_pipeline_manager_slang")
    set_default(false)
option_end()

option("utils_pipeline_manager_spirv_validation")
    set_default(false)
option_end()

if has_config("utils_task_graph") then
    set_config("utils_mem", true)
end

-- ======================
-- Dependencies
-- ======================

add_requires("vulkan")
add_requires("vulkan-memory-allocator 3.1.0")
add_requires("wayland", { system = true, optional = true })
add_requires("libx11", { system = true, optional = true })

if has_config("utils_pipeline_manager_glslang") then
    add_requires("glslang")
end

if has_config("utils_imgui") then
    add_requires("imgui docking")
    add_requires("implot")
end

if has_config("utils_pipeline_manager_spirv_validation") then
    add_requires("spirv-tools", { system = true })
end

if has_config("utils_pipeline_manager_slang") then
    add_requires("slang-bin 2025.11")
end

if has_config("utils_fsr3") then
    -- no package
end

target("daxa")
    set_kind("static")

    add_files("src/**.cpp")

    add_includedirs("include", {public = true})

    add_packages("vulkan", "vulkan-memory-allocator")

    add_defines("DAXA_CMAKE_EXPORT=", {public = true})

    add_defines('DAXA_SHADER_INCLUDE_DIR="include"', {public = true})

    if has_config("utils_fsr3") then
        add_defines("DAXA_BUILT_WITH_UTILS_FSR3=true", {public = true})
        --
    end

    if has_config("utils_imgui") then
        add_defines("DAXA_BUILT_WITH_UTILS_IMGUI=true", {public = true})
        add_packages("imgui", "implot")
    end

    if has_config("utils_mem") then
        add_defines("DAXA_BUILT_WITH_UTILS_MEM=true", {public = true})
    end

    if has_config("utils_pipeline_manager_glslang") then
        add_defines("DAXA_BUILT_WITH_UTILS_PIPELINE_MANAGER_GLSLANG=true", {public = true})
        add_packages("glslang")
    end

    if has_config("utils_pipeline_manager_slang") then
        add_defines("DAXA_BUILT_WITH_UTILS_PIPELINE_MANAGER_SLANG=true", {public = true})
        add_packages("slang-bin")
    end

    if has_config("utils_pipeline_manager_spirv_validation") then
        add_defines("DAXA_BUILT_WITH_UTILS_PIPELINE_MANAGER_SPIRV_VALIDATION=true", {public = true})
        add_packages("spirv-tools")
    end

    if has_config("utils_task_graph") then
        add_defines("DAXA_BUILT_WITH_UTILS_TASK_GRAPH=true", {public = true})
    end

    if has_package("libxcb") then
        add_defines("DAXA_BUILT_WITH_X11=true", { public = true })
    end

    if has_package("wayland") then
        add_defines("DAXA_BUILT_WITH_WAYLAND=true", { public = true })
    end

    add_installfiles("include/**.*", {prefixdir = "include"})