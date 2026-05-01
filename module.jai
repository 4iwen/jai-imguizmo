#if OS == .MACOS {
    #load "bindings/macos/macos.jai";
} else {
    #assert false "ImGuizmo bindings are only generated for macOS.";
}
