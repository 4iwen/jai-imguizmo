//
// This file was auto-generated using the following command:
//
// jai generate.jai
//
#scope_export

#import "jai-imgui";
#import "Math";

ImGuiID :: ID;
ImGuiWindow :: struct #type_info_none {}
ImRect :: struct {
    Min: ImVec2;
    Max: ImVec2;
}



// call inside your own window and before Manipulate() in order to draw gizmo to that window.
// Or pass a specific ImDrawList to draw to (e.g. ImGui::GetForegroundDrawList()).
ImGuizmo_SetDrawlist :: (drawlist: *ImDrawList = null) -> void #foreign imguizmo "?SetDrawlist@ImGuizmo@@YAXPEAUImDrawList@@@Z";

// call BeginFrame right after ImGui_XXXX_NewFrame();
ImGuizmo_BeginFrame :: () -> void #foreign imguizmo "?BeginFrame@ImGuizmo@@YAXXZ";

// this is necessary because when imguizmo is compiled into a dll, and imgui into another
// globals are not shared between them.
// More details at https://stackoverflow.com/questions/19373061/what-happens-to-global-and-static-variables-in-a-shared-library-when-it-is-dynam
// expose method to set imgui context
ImGuizmo_SetImGuiContext :: (ctx: *ImGuiContext) -> void #foreign imguizmo "?SetImGuiContext@ImGuizmo@@YAXPEAUImGuiContext@@@Z";

// return true if mouse cursor is over any gizmo control (axis, plan or screen component)
ImGuizmo_IsOver :: () -> bool #foreign imguizmo "?IsOver@ImGuizmo@@YA_NXZ";

// return true if mouse IsOver or if the gizmo is in moving state
ImGuizmo_IsUsing :: () -> bool #foreign imguizmo "?IsUsing@ImGuizmo@@YA_NXZ";

// return true if the view gizmo is in moving state
ImGuizmo_IsUsingViewManipulate :: () -> bool #foreign imguizmo "?IsUsingViewManipulate@ImGuizmo@@YA_NXZ";

// only check if your mouse is over the view manipulator - no matter whether it's active or not
ImGuizmo_IsViewManipulateHovered :: () -> bool #foreign imguizmo "?IsViewManipulateHovered@ImGuizmo@@YA_NXZ";

// return true if any gizmo is in moving state
ImGuizmo_IsUsingAny :: () -> bool #foreign imguizmo "?IsUsingAny@ImGuizmo@@YA_NXZ";

// enable/disable the gizmo. Stay in the state until next call to Enable.
// gizmo is rendered with gray half transparent color when disabled
ImGuizmo_Enable :: (enable: bool) -> void #foreign imguizmo "?Enable@ImGuizmo@@YAX_N@Z";

// helper functions for manualy editing translation/rotation/scale with an input float
// translation, rotation and scale float points to 3 floats each
// Angles are in degrees (more suitable for human editing)
// example:
// float matrixTranslation[3], matrixRotation[3], matrixScale[3];
// ImGuizmo::DecomposeMatrixToComponents(gizmoMatrix.m16, matrixTranslation, matrixRotation, matrixScale);
// ImGui::InputFloat3("Tr", matrixTranslation, 3);
// ImGui::InputFloat3("Rt", matrixRotation, 3);
// ImGui::InputFloat3("Sc", matrixScale, 3);
// ImGuizmo::RecomposeMatrixFromComponents(matrixTranslation, matrixRotation, matrixScale, gizmoMatrix.m16);
//
// These functions have some numerical stability issues for now. Use with caution.
ImGuizmo_DecomposeMatrixToComponents :: (matrix: *float, translation: *float, rotation: *float, scale: *float) -> void #foreign imguizmo "?DecomposeMatrixToComponents@ImGuizmo@@YAXPEBMPEAM11@Z";
ImGuizmo_RecomposeMatrixFromComponents :: (translation: *float, rotation: *float, scale: *float, matrix: *float) -> void #foreign imguizmo "?RecomposeMatrixFromComponents@ImGuizmo@@YAXPEBM00PEAM@Z";

ImGuizmo_SetRect :: (x: float, y: float, width: float, height: float) -> void #foreign imguizmo "?SetRect@ImGuizmo@@YAXMMMM@Z";

// default is false
ImGuizmo_SetOrthographic :: (isOrthographic: bool) -> void #foreign imguizmo "?SetOrthographic@ImGuizmo@@YAX_N@Z";

// Render coordinate system axes (red X, green Y and blue Z). Usefull for debug/tests
ImGuizmo_DrawAxes :: (view: *float, projection: *float, matrices: *float, matrixCount: s32) -> void #foreign imguizmo "?DrawAxes@ImGuizmo@@YAXPEBM00H@Z";

// Render a cube with face color corresponding to face normal. Usefull for debug/tests
ImGuizmo_DrawCubes :: (view: *float, projection: *float, matrices: *float, matrixCount: s32) -> void #foreign imguizmo "?DrawCubes@ImGuizmo@@YAXPEBM00H@Z";
ImGuizmo_DrawGrid :: (view: *float, projection: *float, matrix: *float, gridSize: float) -> void #foreign imguizmo "?DrawGrid@ImGuizmo@@YAXPEBM00M@Z";

// Render grid with customizable major line step and amount of segments between major lines.
// NOTE(m.wlasiuk) : calling this function with majorStep = 1.0f and subdivision = 1 is equivalent to DrawGrid in terms of the end result but performs more calculations
ImGuizmo_DrawGridCustom :: (view: *float, projection: *float, matrix: *float, gridSize: float, majorStep: float, subdivision: u32) -> void #foreign imguizmo "?DrawGridCustom@ImGuizmo@@YAXPEBM00MMI@Z";

// Render grid with customizable major line step and amount of segments between major lines and with possibility to set custom colors for major, minor and center lines
ImGuizmo_DrawGridCustomColor :: (view: *float, projection: *float, matrix: *float, gridSize: float, majorStep: float, subdivision: u32, majorCol: ImU32, minorCol: ImU32, centerCol: ImU32) -> void #foreign imguizmo "?DrawGridCustomColor@ImGuizmo@@YAXPEBM00MMIIII@Z";

// call it when you want a gizmo
// Needs view and projection matrices.
// matrix parameter is the source matrix (where will be gizmo be drawn) and might be transformed by the function. Return deltaMatrix is optional
// translation is applied in world space
ImGuizmo_Operation :: enum_flags s32 {
    TRANSLATE_X   :: 0x1;
    TRANSLATE_Y   :: 0x2;
    TRANSLATE_Z   :: 0x4;
    ROTATE_X      :: 0x8;
    ROTATE_Y      :: 0x10;
    ROTATE_Z      :: 0x20;
    ROTATE_SCREEN :: 0x40;
    SCALE_X       :: 0x80;
    SCALE_Y       :: 0x100;
    SCALE_Z       :: 0x200;
    BOUNDS        :: 0x400;
    SCALE_XU      :: 0x800;
    SCALE_YU      :: 0x1000;
    SCALE_ZU      :: 0x2000;

    TRANSLATE     :: 0x7;
    ROTATE        :: 0x78;
    SCALE         :: 0x380;
    SCALEU        :: 0x3800;
    UNIVERSAL     :: 0x387f;
}

ImGuizmo_Mode :: enum s32 {
    LOCAL :: 0;
    WORLD :: 1;
}

ImGuizmo_Manipulate :: (view: *float, projection: *float, operation: ImGuizmo_Operation, mode: ImGuizmo_Mode, matrix: *float, deltaMatrix: *float = null, snap: *float = null, localBounds: *float = null, boundsSnap: *float = null) -> bool #foreign imguizmo "?Manipulate@ImGuizmo@@YA_NPEBM0W4OPERATION@1@W4MODE@1@PEAM3000@Z";

//
// Please note that this cubeview is patented by Autodesk : https://patents.google.com/patent/US7782319B2/en
// It seems to be a defensive patent in the US. I don't think it will bring troubles using it as
// other software are using the same mechanics. But just in case, you are now warned!
//
ImGuizmo_ViewManipulate :: (view: *float, length: float, position: ImVec2, size: ImVec2, backgroundColor: ImU32) -> void #foreign imguizmo "?ViewManipulate@ImGuizmo@@YAXPEAMMUImVec2@@1I@Z";

// use this version if you did not call Manipulate before and you are just using ViewManipulate
ImGuizmo_ViewManipulate :: (view: *float, projection: *float, operation: ImGuizmo_Operation, mode: ImGuizmo_Mode, matrix: *float, length: float, position: ImVec2, size: ImVec2, backgroundColor: ImU32) -> void #foreign imguizmo "?ViewManipulate@ImGuizmo@@YAXPEAMPEBMW4OPERATION@1@W4MODE@1@0MUImVec2@@4I@Z";

ImGuizmo_SetAlternativeWindow :: (window: *ImGuiWindow) -> void #foreign imguizmo "?SetAlternativeWindow@ImGuizmo@@YAXPEAUImGuiWindow@@@Z";

ImGuizmo_SetID :: (id: s32) -> void #foreign imguizmo "?SetID@ImGuizmo@@YAXH@Z";

// ID stack/scopes
// Read the FAQ (docs/FAQ.md or http://dearimgui.org/faq) for more details about how ID are handled in dear imgui.
// - Those questions are answered and impacted by understanding of the ID stack system:
//   - "Q: Why is my widget not reacting when I click on it?"
//   - "Q: How can I have widgets with an empty label?"
//   - "Q: How can I have multiple widgets with the same label?"
// - Short version: ID are hashes of the entire ID stack. If you are creating widgets in a loop you most likely
//   want to push a unique identifier (e.g. object pointer, loop index) to uniquely differentiate them.
// - You can also use the "Label##foobar" syntax within widget label to distinguish them from each others.
// - In this header file we use the "label"/"name" terminology to denote a string that will be displayed + used as an ID,
//   whereas "str_id" denote a string that is only used as an ID and not normally displayed.
ImGuizmo_PushID :: (str_id: *u8) -> void #foreign imguizmo "?PushID@ImGuizmo@@YAXPEBD@Z";
ImGuizmo_PushID :: (str_id_begin: *u8, str_id_end: *u8) -> void #foreign imguizmo "?PushID@ImGuizmo@@YAXPEBD0@Z";
ImGuizmo_PushID :: (ptr_id: *void) -> void #foreign imguizmo "?PushID@ImGuizmo@@YAXPEBX@Z";
ImGuizmo_PushID :: (int_id: s32) -> void #foreign imguizmo "?PushID@ImGuizmo@@YAXH@Z";
ImGuizmo_PopID :: () -> void #foreign imguizmo "?PopID@ImGuizmo@@YAXXZ";
ImGuizmo_GetID :: (str_id: *u8) -> ImGuiID #foreign imguizmo "?GetID@ImGuizmo@@YAIPEBD@Z";
ImGuizmo_GetID :: (str_id_begin: *u8, str_id_end: *u8) -> ImGuiID #foreign imguizmo "?GetID@ImGuizmo@@YAIPEBD0@Z";
ImGuizmo_GetID :: (ptr_id: *void) -> ImGuiID #foreign imguizmo "?GetID@ImGuizmo@@YAIPEBX@Z";

// return true if the cursor is over the operation's gizmo
ImGuizmo_IsOver :: (op: ImGuizmo_Operation) -> bool #foreign imguizmo "?IsOver@ImGuizmo@@YA_NW4OPERATION@1@@Z";
ImGuizmo_SetGizmoSizeClipSpace :: (value: float) -> void #foreign imguizmo "?SetGizmoSizeClipSpace@ImGuizmo@@YAXM@Z";

// Allow axis to flip
// When true (default), the guizmo axis flip for better visibility
// When false, they always stay along the positive world/local axis
ImGuizmo_AllowAxisFlip :: (value: bool) -> void #foreign imguizmo "?AllowAxisFlip@ImGuizmo@@YAX_N@Z";

// Configure the limit where axis are hidden
ImGuizmo_SetAxisLimit :: (value: float) -> void #foreign imguizmo "?SetAxisLimit@ImGuizmo@@YAXM@Z";

// Set an axis mask to permanently hide a given axis (true -> hidden, false -> shown)
ImGuizmo_SetAxisMask :: (x: bool, y: bool, z: bool) -> void #foreign imguizmo "?SetAxisMask@ImGuizmo@@YAX_N00@Z";

// Configure the limit where planes are hiden
ImGuizmo_SetPlaneLimit :: (value: float) -> void #foreign imguizmo "?SetPlaneLimit@ImGuizmo@@YAXM@Z";

// from a x,y,z point in space and using Manipulation view/projection matrix, check if mouse is in pixel radius distance of that projected point
ImGuizmo_IsOver :: (position: *float, pixelRadius: float) -> bool #foreign imguizmo "?IsOver@ImGuizmo@@YA_NPEAMM@Z";

ImGuizmo_Color :: enum s32 {
    DIRECTION_X           :: 0;
    DIRECTION_Y           :: 1;
    DIRECTION_Z           :: 2;
    PLANE_X               :: 3;
    PLANE_Y               :: 4;
    PLANE_Z               :: 5;
    SELECTION             :: 6;
    INACTIVE              :: 7;
    TRANSLATION_LINE      :: 8;
    SCALE_LINE            :: 9;
    ROTATION_USING_BORDER :: 10;
    ROTATION_USING_FILL   :: 11;
    HATCHED_AXIS_LINES    :: 12;
    TEXT                  :: 13;
    TEXT_SHADOW           :: 14;
    COUNT                 :: 15;
}

ImGuizmo_Style :: struct {
    Constructor :: (this: *ImGuizmo_Style) -> void #cpp_method #foreign imguizmo "??0Style@ImGuizmo@@QEAA@XZ";

    TranslationLineThickness:   float; // Thickness of lines for translation gizmo
    TranslationLineArrowSize:   float; // Size of arrow at the end of lines for translation gizmo
    RotationLineThickness:      float; // Thickness of lines for rotation gizmo
    RotationOuterLineThickness: float; // Thickness of line surrounding the rotation gizmo
    ScaleLineThickness:         float; // Thickness of lines for scale gizmo
    ScaleLineCircleSize:        float; // Size of circle at the end of lines for scale gizmo
    HatchedAxisLineThickness:   float; // Thickness of hatched axis lines
    CenterCircleSize:           float; // Size of circle at the center of the translate/scale gizmo

    Colors:                     [15] ImVec4;
}

ImGuizmo_GetStyle :: () -> *ImGuizmo_Style #foreign imguizmo "?GetStyle@ImGuizmo@@YAAEAUStyle@1@XZ";

CurveType :: enum s32 {
    CurveNone     :: 0;
    CurveDiscrete :: 1;
    CurveLinear   :: 2;
    CurveSmooth   :: 3;
    CurveBezier   :: 4;
}

EditPoint :: struct {
    curveIndex: s32;
    pointIndex: s32;
}

Delegate :: struct {
    vtable:  *Delegate_VTable;

    focused  := false;
}
Delegate_VTable :: struct #type_info_none {
    GetCurveCount:      #type (this: *Delegate) -> u64 #cpp_method;
    IsVisible:          *void;
    GetCurveType:       *void;
    GetMin:             #type (this: *Delegate) -> *ImVec2 #cpp_method;
    GetMax:             #type (this: *Delegate) -> *ImVec2 #cpp_method;
    GetPointCount:      #type (this: *Delegate, curveIndex: u64) -> u64 #cpp_method;
    GetCurveColor:      #type (this: *Delegate, curveIndex: u64) -> u32 #cpp_method;
    GetPoints:          #type (this: *Delegate, curveIndex: u64) -> *ImVec2 #cpp_method;
    EditPoint:          #type (this: *Delegate, curveIndex: u64, pointIndex: s32, value: ImVec2) -> s32 #cpp_method;
    AddPoint:           #type (this: *Delegate, curveIndex: u64, value: ImVec2) -> void #cpp_method;
    GetBackgroundColor: *void;

    BeginEdit:          *void;
    EndEdit:            *void;

    Destructor:         *void;
}
Delegate_GetCurveCount :: inline (this: *Delegate) -> u64 { return this.vtable.GetCurveCount(this); }

Delegate_GetMin :: inline (this: *Delegate) -> *ImVec2 { return this.vtable.GetMin(this); }
Delegate_GetMax :: inline (this: *Delegate) -> *ImVec2 { return this.vtable.GetMax(this); }
Delegate_GetPointCount :: inline (this: *Delegate, curveIndex: u64) -> u64 { return this.vtable.GetPointCount(this, curveIndex); }
Delegate_GetCurveColor :: inline (this: *Delegate, curveIndex: u64) -> u32 { return this.vtable.GetCurveColor(this, curveIndex); }
Delegate_GetPoints :: inline (this: *Delegate, curveIndex: u64) -> *ImVec2 { return this.vtable.GetPoints(this, curveIndex); }
Delegate_EditPoint :: inline (this: *Delegate, curveIndex: u64, pointIndex: s32, value: ImVec2) -> s32 { return this.vtable.EditPoint(this, curveIndex, pointIndex, value); }
Delegate_AddPoint :: inline (this: *Delegate, curveIndex: u64, value: ImVec2) { this.vtable.AddPoint(this, curveIndex, value); }

vtable :: (obj: *Delegate) -> *Delegate_VTable { return obj.vtable; }


ImCurveEdit_Edit :: (delegate: *Delegate, size: *ImVec2, id: u32, clippingRect: *ImRect = null, selectedPoints: *ImVector(EditPoint) = null) -> s32 #foreign imguizmo "?Edit@ImCurveEdit@@YAHAEAUDelegate@1@AEBUImVec2@@IPEBUImRect@@PEAU?$ImVector@UEditPoint@ImCurveEdit@@@@@Z";
ImCurveEdit_Edit :: (delegate: *Delegate, size: ImVec2, id: u32, clippingRect: *ImRect = null, selectedPoints: *ImVector(EditPoint) = null) -> s32 #no_context {
    return ImCurveEdit_Edit(delegate, *size, id, clippingRect, selectedPoints);
}

#scope_file

imguizmo :: #library,no_dll "x64/ImGuizmo.static";
