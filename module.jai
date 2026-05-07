#if OS == .WINDOWS {
    #load "bindings/windows/windows.jai";
} else #if OS == .MACOS {
    #load "bindings/macos/macos.jai";
} else {
    #assert false "ImGuizmo bindings are only generated for Windows and macOS right now.";
}
