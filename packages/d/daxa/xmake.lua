package("daxa")
    set_homepage("https://github.com/ShatteredWorld/Daxa")
    set_description("A Modern GPU abstraction library for C++")
    set_license("MIT")


    add_urls("https://github.com/ShatteredWorld/Daxa.git")

    -- Local version for development
    add_versions("latest", "personal")

    add_configs("utils_fsr3", { description = "Enable FSR3 utils", default = false, type = "boolean" })
    add_configs("utils_mem", { description = "Enable Mem utils", default = true, type = "boolean" })
    add_configs("utils_pipeline_manager_glslang", { description = "Enable Pipeline Manager GLSLang", default = true, type = "boolean" })
    add_configs("utils_pipeline_manager_slang", { description = "Enable Pipeline Manager Slang", default = false, type = "boolean" })
    add_configs("utils_pipeline_manager_spirv_validation", { description = "Enable Pipeline Manager SPIRV Validation", default = false, type = "boolean" })
    add_configs("utils_task_graph", { description = "Enable Task Graph utils", default = true, type = "boolean" })

    add_deps("vulkansdk")
    add_deps("wayland", { system = true, optional = true })
    add_deps("libx11", { system = true, optional = true })

    on_load(function (package)
        local function add_bool_define(opt, def)
            if package:config(opt) then
                package:add("defines", def .. "=1")
            else
                package:add("defines", def .. "=0")
            end
        end

        package:add("defines", "DAXA_CMAKE_EXPORT=")
        -- Set DAXA_SHADER_INCLUDE_DIR to the installed include path for consumers, in double quotes
        package:add("defines", "DAXA_SHADER_INCLUDE_DIR=\"" .. package:installdir("include") .. "\"")
        add_bool_define("utils_fsr3", "DAXA_BUILT_WITH_UTILS_FSR3")
        add_bool_define("utils_mem", "DAXA_BUILT_WITH_UTILS_MEM")
        add_bool_define("utils_pipeline_manager_glslang", "DAXA_BUILT_WITH_UTILS_PIPELINE_MANAGER_GLSLANG")
        add_bool_define("utils_pipeline_manager_slang", "DAXA_BUILT_WITH_UTILS_PIPELINE_MANAGER_SLANG")
        add_bool_define("utils_pipeline_manager_spirv_validation", "DAXA_BUILT_WITH_UTILS_PIPELINE_MANAGER_SPIRV_VALIDATION")
        add_bool_define("utils_task_graph", "DAXA_BUILT_WITH_UTILS_TASK_GRAPH")

        if package:config("utils_pipeline_manager_glslang") then
            package:add("deps", "glslang 5398d55e33dff7d26fecdd2c35808add986c558c")
        end
    end)

    on_install("windows|x64", "linux|x86_64", function (package)
        local configs = {}
        configs.utils_fsr3 = package:config("utils_fsr3")
        configs.utils_mem = package:config("utils_mem")
        configs.utils_pipeline_manager_glslang = package:config("utils_pipeline_manager_glslang")
        configs.utils_pipeline_manager_slang = package:config("utils_pipeline_manager_slang")
        configs.utils_pipeline_manager_spirv_validation = package:config("utils_pipeline_manager_spirv_validation")
        configs.utils_task_graph = package:config("utils_task_graph")

        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")

        import("package.tools.xmake").install(package, configs)
        os.cp("include/daxa", package:installdir("include"))
    end)

    on_test(function (package)
        --assert(package:has_cxxincludes("daxa/daxa.hpp"))
    end)
package_end()
