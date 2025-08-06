add_rules("mode.release", "mode.debug")
set_project("daxa")

add_requires("vulkan-memory-allocator v3.1.0")
add_requires("vulkansdk")
add_requires("wayland", { system = true, optional = true })
add_requires("libx11", { system = true, optional = true })

option("utils_fsr3")
    set_default(false)
    set_showmenu(true)
option_end()

option("utils_mem")
    set_default(true)
    set_showmenu(true)
option_end()

option("utils_pipeline_manager_glslang")
    set_default(true)
    set_showmenu(true)
option_end()

option("utils_pipeline_manager_slang")
    set_default(false)
    set_showmenu(true)
option_end()

option("utils_pipeline_manager_spirv_validation")
    set_default(false)
    set_showmenu(true)
option_end()

option("utils_task_graph")
    set_default(true)
    set_showmenu(true)
option_end()

if has_config("utils_fsr3", true) then
    --add_requires("ffx_sdk")
end

if has_config("utils_pipeline_manager_glslang") then
    add_requires("glslang 5398d55e33dff7d26fecdd2c35808add986c558c")
    --1.4.309+0
end

if has_config("utils_pipeline_manager_slang") then
    --add_requires("slang-bin")
end

if has_config("utils_pipeline_manager_spirv_validation") then
    add_requires("spirv-tools", { system = true})
end

target("daxa")
    set_kind("static")
    set_warnings("allextra", "pedantic")
    add_languages("cxx20")
    add_includedirs("include/", { public = true })
    --add_files("src/**.cpp")

    add_defines("DAXA_CMAKE_EXPORT=", {public = true})
    add_defines(("DAXA_SHADER_INCLUDE_DIR=" .. os.projectdir() .. "/include"), { public = true })

    add_defines("DAXA_BUILT_WITH_UTILS_FSR3=" .. (has_config("utils_fsr3") and "1" or "0"), { public = true })
    add_defines("DAXA_BUILT_WITH_UTILS_MEM=" .. (has_config("utils_mem") and "1" or "0"), { public = true })
    add_defines("DAXA_BUILT_WITH_UTILS_PIPELINE_MANAGER_GLSLANG=" .. (has_config("utils_pipeline_manager_glslang") and "1" or "0"), { public = true })
    add_defines("DAXA_BUILT_WITH_UTILS_PIPELINE_MANAGER_SLANG=" .. (has_config("utils_pipeline_manager_slang") and "1" or "0"), { public = true })
    add_defines("DAXA_BUILT_WITH_UTILS_PIPELINE_MANAGER_SPIRV_VALIDATION=" .. (has_config("utils_pipeline_manager_spirv_validation") and "1" or "0"), { public = true })
    add_defines("DAXA_BUILT_WITH_UTILS_TASK_GRAPH=" .. (has_config("utils_task_graph") and "1" or "0"), { public = true })

    add_files(
        "src/cpp_wrapper.cpp",

        "src/impl_device.cpp",
        "src/impl_features.cpp",
        "src/impl_instance.cpp",
        "src/impl_core.cpp",
        "src/impl_pipeline.cpp",
        "src/impl_swapchain.cpp",
        "src/impl_command_recorder.cpp",
        "src/impl_gpu_resources.cpp",
        "src/impl_sync.cpp",
        "src/impl_dependencies.cpp",
        "src/impl_timeline_query.cpp",

        "src/utils/impl_task_graph.cpp",
        "src/utils/impl_task_graph_mk2.cpp",
        "src/utils/impl_imgui.cpp",
        "src/utils/impl_fsr3.cpp",
        "src/utils/impl_mem.cpp",
        "src/utils/impl_pipeline_manager.cpp"
    )

    set_options(
        "utils_fsr3",
        "utils_mem", 
        "utils_pipeline_manager_glslang", 
        "utils_pipeline_manager_slang", 
        "utils_pipeline_manager_spirv_validation", 
        "utils_task_graph"
    )
    add_packages("vulkan-memory-allocator", "vulkansdk", { public = true })
    add_packages("spirv-tools", { public = false, optional = true })
    add_packages("slang", { public = false, optional = true })
    add_packages("glslang", { public = false, optional = true })
    add_packages("ffx_sdk", { public = false, optional = true })
    add_packages("wayland", { public = false, optional = true })
    add_packages("libx11", { public = false, optional = true })

    if has_package("libxcb") then
        add_defines("DAXA_BUILT_WITH_X11=true", { public = true })
    end

    if has_package("wayland") then
        add_defines("DAXA_BUILT_WITH_WAYLAND=true", { public = true })
    end

    if is_os("linux") then
        add_syslinks("pthread")
    end
target_end()