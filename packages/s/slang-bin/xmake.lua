package("slang-bin")
    set_kind("binary")
    set_homepage("https://github.com/shader-slang/slang")
    set_description("Prebuilt Slang shader compiler binaries")
    set_license("Apache-2.0")

    set_urls("https://github.com/shader-slang/slang/releases/download/v$(version)/slang-$(version)-$(plat)-x86_64.zip")

    add_versions("2025.11")

    on_load(function (package)
        if package:is_plat("windows") then
            package:set("plat", "windows")
        else
            package:set("plat", "linux")
        end
    end)

    on_install(function (package)
        import("package.tools.unzip").extract(package:originfile(), package:installdir())

        local root = package:installdir()

        package:add("includedirs", path.join(root, "include"))

        package:add("linkdirs", path.join(root, "lib"))
        package:add("links", "slang", "slang-glslang")

        if package:is_plat("windows") then
            package:add("bindirs", path.join(root, "bin"))
        else
            --package:add("ldflags", "-Wl,--disable-new-dtags", {force = true})
        end

        package:add("envs", "PATH", path.join(root, "bin"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({ test = [[
            #include <slang-com-ptr.h>
            #include <slang.h>

            void test() {
                Slang::ComPtr<slang::IGlobalSession> global_session;
                slang::createGlobalSession(global_session.writeRef());
            }
        ]] }, {configs = {languages = "c++17"}}))
    end)