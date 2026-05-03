package("daxa")
    set_homepage("https://github.com/ShatteredWorld/Daxa")
    set_description("A Modern GPU abstraction library for C++")
    set_license("MIT")

    add_urls("https://github.com/ShatteredWorld/Daxa.git")

    add_versions("latest", "personal")

    add_configs("utils_imgui", {description = "Enable ImGui utils", default = false, type = "boolean"})
    add_configs("utils_mem", {description = "Enable memory utils", default = true, type = "boolean"})
    add_configs("utils_task_graph", {description = "Enable task graph utils", default = false, type = "boolean"})
    add_configs("utils_pipeline_glslang", {description = "Enable glslang pipeline manager", default = false, type = "boolean"})
    add_configs("utils_pipeline_slang", {description = "Enable slang pipeline manager", default = false, type = "boolean"})
    add_configs("utils_spirv_validation", {description = "Enable SPIRV validation", default = false, type = "boolean"})
    add_configs("utils_fsr3", {description = "Enable FSR3", default = false, type = "boolean"})

    add_deps("vulkansdk", "vulkan-memory-allocator")
    add_deps("wayland", { system = true, optional = true })
    add_deps("libx11", { system = true, optional = true })

    on_load(function (package)
        if package:config("utils_task_graph") then
            package:config_set("utils_mem", true)
        end

        if package:config("utils_imgui") then
            package:add("deps", "imgui", "implot")
        end

        if package:config("utils_pipeline_manager_slang") then
            package:add("deps", "slang-bin")
        end

        if package:config("utils_pipeline_manager_glslang") then
            package:add("deps", "glslang")
        end

        if package:config("utils_pipeline_manager_spirv_validation") then
            package:add("deps", "spirv-tools")
        end
    end)

    on_install("windows|x64", "linux|x86_64", function (package)
        local configs = {
            utils_imgui = package:config("utils_imgui"),
            utils_mem = package:config("utils_mem"),
            utils_task_graph = package:config("utils_task_graph"),
            utils_fsr3 = package:config("utils_fsr3"),
            utils_pipeline_manager_glslang = package:config("utils_pipeline_manager_glslang"),
            utils_pipeline_manager_slang = package:config("utils_pipeline_manager_slang"),
            utils_pipeline_manager_spirv_validation = package:config("utils_pipeline_manager_spirv_validation"),
        }

        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")

        import("package.tools.xmake").install(package, configs)
        --os.cp("include/daxa", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:has_cxxincludes("daxa/daxa.hpp"))
    end)
package_end()
