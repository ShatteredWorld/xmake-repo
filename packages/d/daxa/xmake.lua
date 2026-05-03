package("daxa")
    set_homepage("https://github.com/Ipotrick/Daxa")
    set_description("A Modern GPU abstraction library for C++")
    set_license("MIT")

    add_urls("https://github.com/ShatteredWorld/Daxa.git")
    add_versions("latest", "personal")

    add_deps("cmake")

    add_configs("utils_imgui", {description = "Enable ImGui utils", default = false, type = "boolean"})
    add_configs("utils_mem", {description = "Enable memory utils", default = true, type = "boolean"})
    add_configs("utils_task_graph", {description = "Enable task graph utils", default = false, type = "boolean"})
    add_configs("utils_pipeline_glslang", {description = "Enable glslang pipeline manager", default = false, type = "boolean"})
    add_configs("utils_pipeline_slang", {description = "Enable slang pipeline manager", default = false, type = "boolean"})
    add_configs("utils_spirv_validation", {description = "Enable SPIRV validation", default = false, type = "boolean"})
    add_configs("utils_fsr3", {description = "Enable FSR3", default = false, type = "boolean"})

    on_install(function (package)
        import("package.tools.cmake").install(package, {
            "-DDAXA_ENABLE_TESTS=OFF",
            "-DDAXA_ENABLE_TOOLS=OFF",
            "-DDAXA_ENABLE_STATIC_ANALYSIS=OFF",

            "-DDAXA_ENABLE_UTILS_IMGUI=" .. (package:config("utils_imgui") and "ON" or "OFF"),
            "-DDAXA_ENABLE_UTILS_MEM=" .. (package:config("utils_mem") and "ON" or "OFF"),
            "-DDAXA_ENABLE_UTILS_TASK_GRAPH=" .. (package:config("utils_task_graph") and "ON" or "OFF"),
            "-DDAXA_ENABLE_UTILS_PIPELINE_MANAGER_GLSLANG=" .. (package:config("utils_pipeline_glslang") and "ON" or "OFF"),
            "-DDAXA_ENABLE_UTILS_PIPELINE_MANAGER_SLANG=" .. (package:config("utils_pipeline_slang") and "ON" or "OFF"),
            "-DDAXA_ENABLE_UTILS_PIPELINE_MANAGER_SPIRV_VALIDATION=" .. (package:config("utils_spirv_validation") and "ON" or "OFF"),
            "-DDAXA_ENABLE_UTILS_FSR3=" .. (package:config("utils_fsr3") and "ON" or "OFF"),

            "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF")
        })
    end)

    on_test(function (package)
        assert(package:has_cxxincludes("daxa/daxa.hpp"))
    end)