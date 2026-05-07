IMGUIZMO_PATH :: "ImGuizmo/src";
IMGUI_PATH    :: "../jai-imgui/src/imgui";

#run,stallable {
    set_build_options_dc(.{do_output = false});

    root_options := get_build_options();
    args := root_options.compile_time_command_line;

    if !generate_imguizmo_bindings(args) {
        compiler_set_workspace_status(.FAILED);
    }
}

generate_imguizmo_bindings :: (args: [] string) -> bool {
    no_compile := array_find(args, "-no_compile");
    compile_debug := array_find(args, "-debug");

    #if OS == .WINDOWS {
        make_directory_if_it_does_not_exist("bindings");
        make_directory_if_it_does_not_exist("bindings/windows");
        make_directory_if_it_does_not_exist("bindings/windows/x64");
    } else #if OS == .MACOS {
        make_directory_if_it_does_not_exist("bindings");
        make_directory_if_it_does_not_exist("bindings/macos");
        make_directory_if_it_does_not_exist("bindings/macos/arm64");
    } else {
        compiler_report("ImGuizmo generator currently supports Windows and macOS only.\n");
        return false;
    }

    if !no_compile {
        success := compile_imguizmo(compile_debug);
        if !success return false;
    }

    output_filename: string;
    opts: Generate_Bindings_Options;
    {
        using opts;

        #if OS == .WINDOWS {
            array_add(*library_search_paths, "bindings/windows/x64");
            array_add(*libraries, .{filename = "ImGuizmo.static", identifier = "imguizmo"});
            output_filename = "bindings/windows/windows.jai";
        } else #if OS == .MACOS {
            array_add(*library_search_paths, "bindings/macos/arm64");
            array_add(*libraries, .{filename = "ImGuizmo", identifier = "imguizmo"});
            output_filename = "bindings/macos/macos.jai";
        } else {
            assert(false);
        }

        generate_library_declarations = false;
        generate_compile_time_struct_checks = false;
        log_stripped_declarations = false;
        auto_detect_enum_prefixes = false;
        strip_enum_prefixes = false;
        strip_flags |= .INLINED_FUNCTIONS;

        header = BINDINGS_HEADER;
        #if OS == .WINDOWS {
            footer = BINDINGS_FOOTER_WINDOWS;
        } else {
            footer = BINDINGS_FOOTER_MACOS;
        }

        array_add(*include_paths, IMGUIZMO_PATH, IMGUI_PATH);
        array_add(*source_files, "bindings.hpp");
        array_add(*extra_clang_arguments,
            "-x", "c++",
            "-std=c++20",
            "-DIMGUI_DEFINE_MATH_OPERATORS",
            "-DWIN32_LEAN_AND_MEAN"
        );
        array_add(*flatten_namespaces, "ImGuizmo", "ImCurveEdit");

        visitor = imguizmo_visitor;
    }

    return generate_bindings(opts, output_filename);
}

compile_imguizmo :: (compile_debug: bool) -> bool {
    #if OS == .WINDOWS {
        windows_extra := string.[
            "/std:c++20",
            "/DIMGUI_DEFINE_MATH_OPERATORS",
            "/DWIN32_LEAN_AND_MEAN",
            tprint("/I%", IMGUI_PATH),
            tprint("/I%", IMGUIZMO_PATH)
        ];

        return build_cpp_static_lib(
            "bindings/windows/x64/ImGuizmo.static",
            tprint("%/ImGuizmo.cpp", IMGUIZMO_PATH),
            tprint("%/ImCurveEdit.cpp", IMGUIZMO_PATH),
            extra = windows_extra,
            debug = compile_debug
        );
    } else #if OS == .MACOS {
        macos_arm64_version_arg := "-mmacos-version-min=11.0";
        macos_extra := string.[
            "-arch", "arm64",
            "-std=c++20",
            "-fno-exceptions",
            "-fno-rtti",
            "-fno-threadsafe-statics",
            macos_arm64_version_arg,
            "-DIMGUI_DEFINE_MATH_OPERATORS",
            tprint("-I%", IMGUI_PATH),
            tprint("-I%", IMGUIZMO_PATH)
        ];

        success := build_cpp_static_lib(
            "bindings/macos/arm64/libImGuizmo",
            tprint("%/ImGuizmo.cpp", IMGUIZMO_PATH),
            tprint("%/ImCurveEdit.cpp", IMGUIZMO_PATH),
            extra = macos_extra,
            debug = compile_debug
        );

        success &&= build_cpp_dynamic_lib(
            "bindings/macos/arm64/ImGuizmo",
            tprint("%/ImGuizmo.cpp", IMGUIZMO_PATH),
            tprint("%/ImCurveEdit.cpp", IMGUIZMO_PATH),
            extra = macos_extra,
            library_files = .["../jai-imgui/macos/ImGui.a"],
            debug = compile_debug
        );

        return success;
    } else {
        return false;
    }
}

imguizmo_visitor :: (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result {
    if !parent_decl {
        if decl.name == "ImGuizmo" || decl.name == "ImCurveEdit" {
            return .RECURSE;
        }

        decl.decl_flags |= .OMIT_FROM_OUTPUT;
        return .STOP;
    }

    if parent_decl.name != "ImGuizmo" && parent_decl.name != "ImCurveEdit" {
        return .RECURSE;
    }

    if decl.kind == {
        case .FUNCTION;
            if parent_decl.name == "ImGuizmo" {
                decl.output_name = tprint("ImGuizmo_%", decl.name);
            } else if parent_decl.name == "ImCurveEdit" {
                decl.output_name = tprint("ImCurveEdit_%", decl.name);
            }

        case .ENUM;
            if decl.name == "OPERATION" {
                decl.output_name = "ImGuizmo_Operation";
                en := cast(*Enum) decl;
                en.flags |= .IS_ENUM_FLAGS;
                en.flags |= .VALUES_IN_HEX;
            } else if decl.name == "MODE" {
                decl.output_name = "ImGuizmo_Mode";
            } else if decl.name == "COLOR" {
                decl.output_name = "ImGuizmo_Color";
            }

        case .STRUCT;
            if decl.name == "Style" {
                decl.output_name = "ImGuizmo_Style";
            }
    }

    return .RECURSE;
}

#scope_file

#import "Basic";
#import "Bindings_Generator";
#import "BuildCpp";
#import "Compiler";
#import "File";
#import "String";

BINDINGS_HEADER :: #string END
#scope_export

#import "jai-imgui";
#import "Math";

ImGuiID :: ID;
ImGuiWindow :: struct #type_info_none {}
ImRect :: struct {
    Min: ImVec2;
    Max: ImVec2;
}
END

BINDINGS_FOOTER_MACOS :: #string END
imguizmo :: #library,no_dll "arm64/libImGuizmo";
END

BINDINGS_FOOTER_WINDOWS :: #string END
imguizmo :: #library,no_dll "x64/ImGuizmo.static";
END
