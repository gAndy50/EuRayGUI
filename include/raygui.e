--EuRayGUI
--Wrapper of RayGUI for Euphoria Programming Language
--Written by Andy P.

include std/ffi.e
include std/machine.e
include std/os.e

public atom gui = 0

public constant RAYGUI_VERSION_MAJOR = 4,
				RAYGUI_VERSION_MINOR = 0,
				RAYGUI_VERSION_PATCH = 0
				
public constant RAYGUI_VERSION = "4.0"

ifdef WINDOWS then
	gui = open_dll("raygui.dll")
	elsifdef LINUX or FREEBSD then
	gui = open_dll("raygui.so")
	elsifdef OSX then
	gui = open_dll("raygui.dylib")
end ifdef

public constant Vector2 = define_c_struct({
	C_FLOAT, --x
	C_FLOAT  --y
})

public constant Vector3 = define_c_struct({
	C_FLOAT, --x
	C_FLOAT, --y
	C_FLOAT  --z
})

public constant Color = define_c_struct({
	C_UCHAR, --r
	C_UCHAR, --g
	C_UCHAR, --b
	C_UCHAR  --a
})

public constant Rectangle = define_c_struct({
	C_FLOAT, --x
	C_FLOAT, --y
	C_FLOAT, --width
	C_FLOAT  --height
})

public constant Texture2D = define_c_struct({
	C_UINT, --id
	C_INT, --width
	C_INT, --height
	C_INT, --mipmaps
	C_INT  --format
})

public constant Image = define_c_struct({
	C_POINTER, --data
	C_INT, --width
	C_INT, --height
	C_INT, --mipmaps
	C_INT  --format
})

public constant GlyphInfo = define_c_struct({
	C_INT, --value
	C_INT, --offsetX
	C_INT, --offsetY
	C_INT, --advanceX
	Image  --image
})

public constant Font = define_c_struct({
	C_INT, --baseSize
	C_INT, --glyphCount
	C_INT, --glyphPadding
	Texture2D, --texture
	C_POINTER, --recs (Rectangle)
	C_POINTER  --glyphs (GlyphInfo)
})

public constant GuiStyleProp = define_c_struct({
	C_USHORT, --controlID
	C_USHORT, --propertyID
	C_INT     --propertyValue
})

public enum type GuiState
	STATE_NORMAL = 0,
	STATE_FOCUSED,
	STATE_PRESSED,
	STATE_DISABLED
end type

public enum type GuiTextAlignment
	TEXT_ALIGN_LEFT = 0,
	TEXT_ALIGN_CENTER,
	TEXT_ALIGN_RIGHT
end type

public enum type GuiTextAlignmentVertical
	TEXT_ALIGN_TOP = 0,
	TEXT_ALIGN_MIDDLE,
	TEXT_ALIGN_BOTTOM
end type

public enum type GuiTextWrapMode
	TEXT_WRAP_NONE = 0,
	TEXT_WRAP_CHAR,
	TEXT_WRAP_WORD
end type

public enum type GuiControl
	DEFAULT = 0,
	LABEL,
	BUTTON,
	TOGGLE,
	SLIDER,
	PROGRESSBAR,
	CHECKBOX,
	COMBOBOX,
	DROPDOWNBOX,
	TEXTBOX,
	VALUEBOX,
	SPINNER,
	LISTVIEW,
	COLORPICKER,
	SCROLLBAR,
	STATUSBAR
end type

public enum type GuiControlProperty
	BORDER_COLOR_NORMAL = 0,
	BASE_COLOR_NORMAL,
	TEXT_COLOR_NORMAL,
	BORDER_COLOR_FOCUSED,
	BASE_COLOR_FOCUSED,
	TEXT_COLOR_FOCUSED,
	BORDER_COLOR_PRESSED,
	BASE_COLOR_PRESSED,
	TEXT_COLOR_PRESSED,
	BORDER_COLOR_DISABLED,
	BASE_COLOR_DISABLED,
	TEXT_COLOR_DISABLED,
	BORDER_WIDTH,
	TEXT_PADDING,
	TEXT_ALIGNMENT
end type

public enum type GuiDefaultProperty
	TEXT_SIZE = 16,
	TEXT_SPACING,
	LINE_COLOR,
	BACKGROUND_COLOR,
	TEXT_LINE_SPACING,
	TEXT_ALIGNMENT_VERTICAL,
	TEXT_WRAP_MODE
end type

public enum type GuiToggleProperty
	GROUP_PADDING = 16
end type

public enum type GuiSliderProperty
	SLIDER_WIDTH = 16,
	SLIDER_PADDING
end type

public enum type GuiProgressBarProperty
	PROGRESS_PADDING = 16
end type

public enum type GuiScrollBarProperty
	ARROWS_SIZE = 16,
	ARROWS_VISIBLE,
	SCROLL_SLIDER_PADDING,
	SCROLL_SLIDER_SIZE,
	SCROLL_PADDING,
	SCROLL_SPEED
end type

public enum type GuiCheckBoxProperty
	CHECK_PADDING = 16
end type

public enum type GuiComboBoxProperty
	COMBO_BUTTON_WIDTH = 16,
	COMBO_BUTTON_SPACING
end type

public enum type GuiDropdownBoxProperty
	ARROW_PADDING= 15,
	DROPDOWN_ITEMS_SPACING
end type

public enum type GuiTextBoxProperty
	TEXT_READONLY = 16
end type

public enum type GuiSpinnerProperty
	SPIN_BUTTON_WIDTH = 16,
	SPIN_BUTTON_SPACING
end type

public enum type GuiListViewProperty
	LIST_ITEMS_HEIGHT = 16,
	LIST_ITEMS_SPACING,
	SCROLLBAR_WIDTH,
	SCROLLBAR_SIDE
end type

public enum type GuiColorPickerProperty
	COLOR_SELECTOR_SIZE = 16,
	HUEBAR_WIDTH,
	HUEBAR_PADDING,
	HUEBAR_SELECTOR_HEIGHT,
	HUEBAR_SELECTOR_OVERFLOW
end type

public constant SCROLLBAR_LEFT_SIDE = 0
public constant SCROLLBAR_RIGHT_SIDE = 1

public constant xGuiEnable = define_c_proc(gui,"+GuiEnable",{}),
				xGuiDisable = define_c_proc(gui,"+GuiDisable",{}),
				xGuiLock = define_c_proc(gui,"+GuiLock",{}),
				xGuiUnlock = define_c_proc(gui,"+GuiUnlock",{}),
				xGuiIsLocked = define_c_func(gui,"+GuiIsLocked",{},C_BOOL),
				xGuiSetAlpha = define_c_proc(gui,"+GuiSetAlpha",{C_FLOAT}),
				xGuiSetState = define_c_proc(gui,"+GuiSetState",{C_INT}),
				xGuiGetState = define_c_func(gui,"+GuiGetState",{},C_INT)
				
public procedure GuiEnable()
	c_proc(xGuiEnable,{})
end procedure

public procedure GuiDisable()
	c_proc(xGuiDisable,{})
end procedure

public procedure GuiLock()
	c_proc(xGuiLock,{})
end procedure

public procedure GuiUnlock()
	c_proc(xGuiUnlock,{})
end procedure

public function GuiIsLocked()
	return c_func(xGuiIsLocked,{})
end function

public procedure GuiSetAlpha(atom alpha)
	c_proc(xGuiSetAlpha,{alpha})
end procedure

public procedure GuiSetState(atom state)
	c_proc(xGuiSetState,{state})
end procedure

public function GuiGetState()
	return c_func(xGuiGetState,{})
end function

public constant xGuiSetFont = define_c_proc(gui,"+GuiSetFont",{Font}),
				xGuiGetFont = define_c_func(gui,"+GuiGetFont",{},Font)
				
public procedure GuiSetFont(sequence font)
	c_proc(xGuiSetFont,{font})
end procedure

public function GuiGetFont()
	return c_func(xGuiGetFont,{})
end function

public constant xGuiSetStyle = define_c_proc(gui,"+GuiSetStyle",{C_INT,C_INT,C_INT}),
				xGuiGetStyle = define_c_func(gui,"+GuiGetStyle",{C_INT,C_INT},C_INT)
				
public procedure GuiSetStyle(atom control,atom property,atom val)
	c_proc(xGuiSetStyle,{control,property,val})
end procedure

public function GuiGetStyle(atom control,atom property)
	return c_func(xGuiGetStyle,{control,property})
end function

public constant xGuiLoadStyle = define_c_proc(gui,"+GuiLoadStyle",{C_STRING}),
				xGuiLoadStyleDefault = define_c_proc(gui,"+GuiLoadStyleDefault",{})
				
public procedure GuiLoadStyle(sequence fName)
	c_proc(xGuiLoadStyle,{fName})
end procedure

public procedure GuiLoadStyleDefault()
	c_proc(xGuiLoadStyleDefault,{})
end procedure

public constant xGuiEnableTooltip = define_c_proc(gui,"+GuiEnableTolltip",{}),
				xGuiDisableTooltip = define_c_proc(gui,"+GuiDisableTooltip",{}),
				xGuiSetTooltip = define_c_proc(gui,"+GuiSetTooltip",{C_STRING})
				
public procedure GuiEnableTooltip()
	c_proc(xGuiEnableTooltip,{})
end procedure

public procedure GuiDisableTooltip()
	c_proc(xGuiDisableTooltip,{})
end procedure

public procedure GuiSetTooltip(sequence tooltip)
	c_proc(xGuiSetTooltip,{tooltip})
end procedure

public constant xGuiIconText = define_c_func(gui,"+GuiIconText",{C_INT,C_STRING},C_STRING),
				xGuiSetIconScale = define_c_proc(gui,"+GuiSetIconScale",{C_INT}),
				xGuiGetIcons = define_c_func(gui,"+GuiGetIcons",{},C_POINTER),
				xGuiLoadIcons = define_c_func(gui,"+GuiLoadIcons",{C_STRING,C_BOOL},C_POINTER),
				xGuiDrawIcon = define_c_proc(gui,"+GuiDrawIcon",{C_INT,C_INT,C_INT,C_INT,Color})
				
public function GuiIconText(atom id,sequence text)
	return c_func(xGuiIconText,{id,text})
end function

public procedure GuiSetIconScale(atom scale)
	c_proc(xGuiSetIconScale,{scale})
end procedure

public function GuiGetIcons()
	return c_func(xGuiGetIcons,{})
end function

public function GuiLoadIcons(sequence fName,integer loadIcons)
	return c_func(xGuiLoadIcons,{fName,loadIcons})
end function

public procedure GuiDrawIcon(atom id,atom x,atom y,atom size,sequence color)
	c_proc(xGuiDrawIcon,{id,x,y,size,color})
end procedure

public constant xGuiWindowBox = define_c_func(gui,"+GuiWindowBox",{Rectangle,C_STRING},C_INT),
				xGuiGroupBox = define_c_func(gui,"+GuiGroupBox",{Rectangle,C_STRING},C_INT),
				xGuiLine = define_c_func(gui,"+GuiLine",{Rectangle,C_STRING},C_INT),
				xGuiPanel = define_c_func(gui,"+GuiPanel",{Rectangle,C_STRING},C_INT),
				xGuiTabBar = define_c_func(gui,"+GuiTabBar",{Rectangle,C_STRING,C_INT,C_POINTER},C_INT),
				xGuiScrollPanel = define_c_func(gui,"+GuiScrollPanel",{Rectangle,C_STRING,Rectangle,C_POINTER,C_POINTER},C_INT)
				
public function GuiWindowBox(sequence bounds,sequence title)
	return c_func(xGuiWindowBox,{bounds,title})
end function

public function GuiGroupBox(sequence bounds,sequence text)
	return c_func(xGuiGroupBox,{bounds,text})
end function

public function GuiLine(sequence bounds,sequence text)
	return c_func(xGuiLine,{bounds,text})
end function

public function GuiPanel(sequence bounds,sequence text)
	return c_func(xGuiPanel,{bounds,text})
end function

public function GuiTabBar(sequence bounds,sequence text,atom count,atom active)
	return c_func(xGuiTabBar,{bounds,text,count,active})
end function

public function GuiScrollPanel(sequence bounds,sequence text,sequence content,atom scroll,atom view)
	return c_func(xGuiScrollPanel,{bounds,text,content,scroll,view})
end function

public constant xGuiLabel = define_c_func(gui,"+GuiLabel",{Rectangle,C_STRING},C_INT),
				xGuiButton = define_c_func(gui,"+GuiButton",{Rectangle,C_STRING},C_INT),
				xGuiLabelButton = define_c_func(gui,"+GuiLabelButton",{Rectangle,C_STRING},C_INT),
				xGuiToggle = define_c_func(gui,"+GuiToggle",{Rectangle,C_STRING,C_POINTER},C_INT),
				xGuiToggleGroup = define_c_func(gui,"+GuiToggleGroup",{Rectangle,C_STRING,C_POINTER},C_INT),
				xGuiToggleSlider = define_c_func(gui,"+GuiToggleSlider",{Rectangle,C_STRING,C_POINTER},C_INT),
				xGuiCheckBox = define_c_func(gui,"+GuiCheckBox",{Rectangle,C_STRING,C_POINTER},C_INT),
				xGuiComboBox = define_c_func(gui,"+GuiComboBox",{Rectangle,C_STRING,C_POINTER},C_INT)
				
public function GuiLabel(sequence bounds,sequence text)
	return c_func(xGuiLabel,{bounds,text})
end function

public function GuiButton(sequence bounds,sequence text)
	return c_func(xGuiButton,{bounds,text})
end function

public function GuiLabelButton(sequence bounds,sequence text)
	return c_func(xGuiLabelButton,{bounds,text})
end function

public function GuiToggle(sequence bounds,sequence text,atom active)
	return c_func(xGuiToggle,{bounds,text,active})
end function

public function GuiToggleGroup(sequence bounds,sequence text,atom active)
	return c_func(xGuiToggleGroup,{bounds,text,active})
end function

public function GuiToggleSlider(sequence bounds,sequence text,atom active)
	return c_func(xGuiToggleSlider,{bounds,text,active})
end function

public function GuiCheckBox(sequence bounds,sequence text,atom checked)
	return c_func(xGuiCheckBox,{bounds,text,checked})
end function

public function GuiComboBox(sequence bounds,sequence text,atom active)
	return c_func(xGuiComboBox,{bounds,text,active})
end function

public constant xGuiDropdownBox = define_c_func(gui,"+GuiDropdownBox",{Rectangle,C_STRING,C_POINTER,C_BOOL},C_INT),
				xGuiSpinner = define_c_func(gui,"+GuiSpinner",{Rectangle,C_STRING,C_POINTER,C_INT,C_INT,C_BOOL},C_INT),
				xGuiValueBox = define_c_func(gui,"+GuiValueBox",{Rectangle,C_STRING,C_POINTER,C_INT,C_INT,C_BOOL},C_INT),
				xGuiTextBox = define_c_func(gui,"+GuiTextBox",{Rectangle,C_STRING,C_INT,C_BOOL},C_INT)
				
public function GuiDropdownBox(sequence bounds,sequence text,atom active,atom editMode)
	return c_func(xGuiDropdownBox,{bounds,text,active,editMode})
end function

public function GuiSpinner(sequence bounds,sequence text,atom val,atom min,atom max,atom editMode)
	return c_func(xGuiSpinner,{bounds,text,val,min,max,editMode})
end function

public function GuiValueBox(sequence bounds,sequence text,atom val,atom min,atom max,atom editMode)
	return c_func(xGuiValueBox,{bounds,text,val,min,max,editMode})
end function

public function GuiTextBox(sequence bounds,sequence text,atom size,atom editMode)
	return c_func(xGuiTextBox,{bounds,text,size,editMode})
end function

public constant xGuiSlider = define_c_func(gui,"+GuiSlider",{Rectangle,C_STRING,C_STRING,C_POINTER,C_FLOAT,C_FLOAT},C_INT),
				xGuiSliderBar = define_c_func(gui,"+GuiSliderBar",{Rectangle,C_STRING,C_STRING,C_POINTER,C_FLOAT,C_FLOAT},C_INT),
				xGuiProgressBar = define_c_func(gui,"+GuiProgressBar",{Rectangle,C_STRING,C_STRING,C_POINTER,C_FLOAT,C_FLOAT},C_INT),
				xGuiStatusBar = define_c_func(gui,"+GuiStatusBar",{Rectangle,C_STRING},C_INT),
				xGuiDummyRec = define_c_func(gui,"+GuiDummyRec",{Rectangle,C_STRING},C_INT),
				xGuiGrid = define_c_func(gui,"+GuiGrid",{Rectangle,C_STRING,C_FLOAT,C_INT,C_POINTER},C_INT)
				
public function GuiSlider(sequence bounds,sequence left,sequence right,atom val,atom min,atom max)
	return c_func(xGuiSlider,{bounds,left,right,val,min,max})
end function

public function GuiSliderBar(sequence bounds,sequence left,sequence right,atom val,atom min,atom max)
	return c_func(xGuiSliderBar,{bounds,left,right,val,min,max})
end function

public function GuiProgressBar(sequence bounds,sequence left,sequence right,atom val,atom min,atom max)
	return c_func(xGuiProgressBar,{bounds,left,right,val,min,max})
end function

public function GuiStatusBar(sequence bounds,sequence text)
	return c_func(xGuiStatusBar,{bounds,text})
end function

public function GuiDummyRec(sequence bounds,sequence text)
	return c_func(xGuiDummyRec,{bounds,text})
end function

public function GuiGrid(sequence bounds,sequence text,atom space,atom subdivs,atom mouseCell)
	return c_func(xGuiGrid,{bounds,text,space,subdivs,mouseCell})
end function

public constant xGuiListView = define_c_func(gui,"+GuiListView",{Rectangle,C_STRING,C_POINTER,C_POINTER},C_INT),
				xGuiListViewEx = define_c_func(gui,"+GuiListViewEx",{Rectangle,C_STRING,C_INT,C_POINTER,C_POINTER,C_POINTER},C_INT),
				xGuiMessageBox = define_c_func(gui,"+GuiMessageBox",{Rectangle,C_STRING,C_STRING,C_STRING},C_INT),
				xGuiTextInputBox = define_c_func(gui,"+GuiTextInputBox",{Rectangle,C_STRING,C_STRING,C_STRING,C_STRING,C_INT,C_POINTER},C_INT),
				xGuiColorPicker = define_c_func(gui,"+GuiColorPicker",{Rectangle,C_STRING,C_POINTER},C_INT),
				xGuiColorPanel = define_c_func(gui,"+GuiColorPanel",{Rectangle,C_STRING,C_POINTER},C_INT),
				xGuiColorBarAlpha = define_c_func(gui,"+GuiColorBarAlpha",{Rectangle,C_STRING,C_POINTER},C_INT),
				xGuiColorBarHue = define_c_func(gui,"+GuiColorBarHue",{Rectangle,C_STRING,C_POINTER},C_INT),
				xGuiColorPickerHSV = define_c_func(gui,"+GuiColorPickerHSV",{Rectangle,C_STRING,C_POINTER},C_INT),
				xGuiColorPanelHSV = define_c_func(gui,"+GuiColorPanelHSV",{Rectangle,C_STRING,C_POINTER},C_INT)
				
public function GuiListView(sequence bounds,sequence text,atom index,atom active)
	return c_func(xGuiListView,{bounds,text,index,active})
end function

public function GuiListViewEx(sequence bounds,sequence text,atom count,atom index,atom active,atom focus)
	return c_func(xGuiListViewEx,{bounds,text,count,index,active,focus})
end function

public function GuiMessageBox(sequence bounds,sequence title,sequence message,sequence btns)
	return c_func(xGuiMessageBox,{bounds,title,message,btns})
end function

public function GuiTextInputBox(sequence bounds,sequence title,sequence message,sequence btns,sequence text,atom size,atom view)
	return c_func(xGuiTextInputBox,{bounds,title,message,btns,text,size,view})
end function

public function GuiColorPicker(sequence bounds,sequence text,atom col)
	return c_func(xGuiColorPicker,{bounds,text,col})
end function

public function GuiColorPanel(sequence bounds,sequence text,atom col)
	return c_func(xGuiColorPanel,{bounds,text,col})
end function

public function GuiColorBarAlpha(sequence bounds,sequence text,atom alpha)
	return c_func(xGuiColorBarAlpha,{bounds,text,alpha})
end function

public function GuiColorBarHue(sequence bounds,sequence text,atom val)
	return c_func(xGuiColorBarHue,{bounds,text,val})
end function

public function GuiColorPickerHSV(sequence bounds,sequence text,atom hsv)
	return c_func(xGuiColorPickerHSV,{bounds,text,hsv})
end function

public function GuiColorPanelHSV(sequence bounds,sequence text,atom hsv)
	return c_func(xGuiColorPanelHSV,{bounds,text,hsv})
end function

public enum type GuiIconName
	ICON_NONE                     = 0,
    ICON_FOLDER_FILE_OPEN         = 1,
    ICON_FILE_SAVE_CLASSIC        = 2,
    ICON_FOLDER_OPEN              = 3,
    ICON_FOLDER_SAVE              = 4,
    ICON_FILE_OPEN                = 5,
    ICON_FILE_SAVE                = 6,
    ICON_FILE_EXPORT              = 7,
    ICON_FILE_ADD                 = 8,
    ICON_FILE_DELETE              = 9,
    ICON_FILETYPE_TEXT            = 10,
    ICON_FILETYPE_AUDIO           = 11,
    ICON_FILETYPE_IMAGE           = 12,
    ICON_FILETYPE_PLAY            = 13,
    ICON_FILETYPE_VIDEO           = 14,
    ICON_FILETYPE_INFO            = 15,
    ICON_FILE_COPY                = 16,
    ICON_FILE_CUT                 = 17,
    ICON_FILE_PASTE               = 18,
    ICON_CURSOR_HAND              = 19,
    ICON_CURSOR_POINTER           = 20,
    ICON_CURSOR_CLASSIC           = 21,
    ICON_PENCIL                   = 22,
    ICON_PENCIL_BIG               = 23,
    ICON_BRUSH_CLASSIC            = 24,
    ICON_BRUSH_PAINTER            = 25,
    ICON_WATER_DROP               = 26,
    ICON_COLOR_PICKER             = 27,
    ICON_RUBBER                   = 28,
    ICON_COLOR_BUCKET             = 29,
    ICON_TEXT_T                   = 30,
    ICON_TEXT_A                   = 31,
    ICON_SCALE                    = 32,
    ICON_RESIZE                   = 33,
    ICON_FILTER_POINT             = 34,
    ICON_FILTER_BILINEAR          = 35,
    ICON_CROP                     = 36,
    ICON_CROP_ALPHA               = 37,
    ICON_SQUARE_TOGGLE            = 38,
    ICON_SYMMETRY                 = 39,
    ICON_SYMMETRY_HORIZONTAL      = 40,
    ICON_SYMMETRY_VERTICAL        = 41,
    ICON_LENS                     = 42,
    ICON_LENS_BIG                 = 43,
    ICON_EYE_ON                   = 44,
    ICON_EYE_OFF                  = 45,
    ICON_FILTER_TOP               = 46,
    ICON_FILTER                   = 47,
    ICON_TARGET_POINT             = 48,
    ICON_TARGET_SMALL             = 49,
    ICON_TARGET_BIG               = 50,
    ICON_TARGET_MOVE              = 51,
    ICON_CURSOR_MOVE              = 52,
    ICON_CURSOR_SCALE             = 53,
    ICON_CURSOR_SCALE_RIGHT       = 54,
    ICON_CURSOR_SCALE_LEFT        = 55,
    ICON_UNDO                     = 56,
    ICON_REDO                     = 57,
    ICON_REREDO                   = 58,
    ICON_MUTATE                   = 59,
    ICON_ROTATE                   = 60,
    ICON_REPEAT                   = 61,
    ICON_SHUFFLE                  = 62,
    ICON_EMPTYBOX                 = 63,
    ICON_TARGET                   = 64,
    ICON_TARGET_SMALL_FILL        = 65,
    ICON_TARGET_BIG_FILL          = 66,
    ICON_TARGET_MOVE_FILL         = 67,
    ICON_CURSOR_MOVE_FILL         = 68,
    ICON_CURSOR_SCALE_FILL        = 69,
    ICON_CURSOR_SCALE_RIGHT_FILL  = 70,
    ICON_CURSOR_SCALE_LEFT_FILL   = 71,
    ICON_UNDO_FILL                = 72,
    ICON_REDO_FILL                = 73,
    ICON_REREDO_FILL              = 74,
    ICON_MUTATE_FILL              = 75,
    ICON_ROTATE_FILL              = 76,
    ICON_REPEAT_FILL              = 77,
    ICON_SHUFFLE_FILL             = 78,
    ICON_EMPTYBOX_SMALL           = 79,
    ICON_BOX                      = 80,
    ICON_BOX_TOP                  = 81,
    ICON_BOX_TOP_RIGHT            = 82,
    ICON_BOX_RIGHT                = 83,
    ICON_BOX_BOTTOM_RIGHT         = 84,
    ICON_BOX_BOTTOM               = 85,
    ICON_BOX_BOTTOM_LEFT          = 86,
    ICON_BOX_LEFT                 = 87,
    ICON_BOX_TOP_LEFT             = 88,
    ICON_BOX_CENTER               = 89,
    ICON_BOX_CIRCLE_MASK          = 90,
    ICON_POT                      = 91,
    ICON_ALPHA_MULTIPLY           = 92,
    ICON_ALPHA_CLEAR              = 93,
    ICON_DITHERING                = 94,
    ICON_MIPMAPS                  = 95,
    ICON_BOX_GRID                 = 96,
    ICON_GRID                     = 97,
    ICON_BOX_CORNERS_SMALL        = 98,
    ICON_BOX_CORNERS_BIG          = 99,
    ICON_FOUR_BOXES               = 100,
    ICON_GRID_FILL                = 101,
    ICON_BOX_MULTISIZE            = 102,
    ICON_ZOOM_SMALL               = 103,
    ICON_ZOOM_MEDIUM              = 104,
    ICON_ZOOM_BIG                 = 105,
    ICON_ZOOM_ALL                 = 106,
    ICON_ZOOM_CENTER              = 107,
    ICON_BOX_DOTS_SMALL           = 108,
    ICON_BOX_DOTS_BIG             = 109,
    ICON_BOX_CONCENTRIC           = 110,
    ICON_BOX_GRID_BIG             = 111,
    ICON_OK_TICK                  = 112,
    ICON_CROSS                    = 113,
    ICON_ARROW_LEFT               = 114,
    ICON_ARROW_RIGHT              = 115,
    ICON_ARROW_DOWN               = 116,
    ICON_ARROW_UP                 = 117,
    ICON_ARROW_LEFT_FILL          = 118,
    ICON_ARROW_RIGHT_FILL         = 119,
    ICON_ARROW_DOWN_FILL          = 120,
    ICON_ARROW_UP_FILL            = 121,
    ICON_AUDIO                    = 122,
    ICON_FX                       = 123,
    ICON_WAVE                     = 124,
    ICON_WAVE_SINUS               = 125,
    ICON_WAVE_SQUARE              = 126,
    ICON_WAVE_TRIANGULAR          = 127,
    ICON_CROSS_SMALL              = 128,
    ICON_PLAYER_PREVIOUS          = 129,
    ICON_PLAYER_PLAY_BACK         = 130,
    ICON_PLAYER_PLAY              = 131,
    ICON_PLAYER_PAUSE             = 132,
    ICON_PLAYER_STOP              = 133,
    ICON_PLAYER_NEXT              = 134,
    ICON_PLAYER_RECORD            = 135,
    ICON_MAGNET                   = 136,
    ICON_LOCK_CLOSE               = 137,
    ICON_LOCK_OPEN                = 138,
    ICON_CLOCK                    = 139,
    ICON_TOOLS                    = 140,
    ICON_GEAR                     = 141,
    ICON_GEAR_BIG                 = 142,
    ICON_BIN                      = 143,
    ICON_HAND_POINTER             = 144,
    ICON_LASER                    = 145,
    ICON_COIN                     = 146,
    ICON_EXPLOSION                = 147,
    ICON_1UP                      = 148,
    ICON_PLAYER                   = 149,
    ICON_PLAYER_JUMP              = 150,
    ICON_KEY                      = 151,
    ICON_DEMON                    = 152,
    ICON_TEXT_POPUP               = 153,
    ICON_GEAR_EX                  = 154,
    ICON_CRACK                    = 155,
    ICON_CRACK_POINTS             = 156,
    ICON_STAR                     = 157,
    ICON_DOOR                     = 158,
    ICON_EXIT                     = 159,
    ICON_MODE_2D                  = 160,
    ICON_MODE_3D                  = 161,
    ICON_CUBE                     = 162,
    ICON_CUBE_FACE_TOP            = 163,
    ICON_CUBE_FACE_LEFT           = 164,
    ICON_CUBE_FACE_FRONT          = 165,
    ICON_CUBE_FACE_BOTTOM         = 166,
    ICON_CUBE_FACE_RIGHT          = 167,
    ICON_CUBE_FACE_BACK           = 168,
    ICON_CAMERA                   = 169,
    ICON_SPECIAL                  = 170,
    ICON_LINK_NET                 = 171,
    ICON_LINK_BOXES               = 172,
    ICON_LINK_MULTI               = 173,
    ICON_LINK                     = 174,
    ICON_LINK_BROKE               = 175,
    ICON_TEXT_NOTES               = 176,
    ICON_NOTEBOOK                 = 177,
    ICON_SUITCASE                 = 178,
    ICON_SUITCASE_ZIP             = 179,
    ICON_MAILBOX                  = 180,
    ICON_MONITOR                  = 181,
    ICON_PRINTER                  = 182,
    ICON_PHOTO_CAMERA             = 183,
    ICON_PHOTO_CAMERA_FLASH       = 184,
    ICON_HOUSE                    = 185,
    ICON_HEART                    = 186,
    ICON_CORNER                   = 187,
    ICON_VERTICAL_BARS            = 188,
    ICON_VERTICAL_BARS_FILL       = 189,
    ICON_LIFE_BARS                = 190,
    ICON_INFO                     = 191,
    ICON_CROSSLINE                = 192,
    ICON_HELP                     = 193,
    ICON_FILETYPE_ALPHA           = 194,
    ICON_FILETYPE_HOME            = 195,
    ICON_LAYERS_VISIBLE           = 196,
    ICON_LAYERS                   = 197,
    ICON_WINDOW                   = 198,
    ICON_HIDPI                    = 199,
    ICON_FILETYPE_BINARY          = 200,
    ICON_HEX                      = 201,
    ICON_SHIELD                   = 202,
    ICON_FILE_NEW                 = 203,
    ICON_FOLDER_ADD               = 204,
    ICON_ALARM                    = 205,
    ICON_CPU                      = 206,
    ICON_ROM                      = 207,
    ICON_STEP_OVER                = 208,
    ICON_STEP_INTO                = 209,
    ICON_STEP_OUT                 = 210,
    ICON_RESTART                  = 211,
    ICON_BREAKPOINT_ON            = 212,
    ICON_BREAKPOINT_OFF           = 213,
    ICON_BURGER_MENU              = 214,
    ICON_CASE_SENSITIVE           = 215,
    ICON_REG_EXP                  = 216,
    ICON_FOLDER                   = 217,
    ICON_FILE                     = 218,
    ICON_SAND_TIMER               = 219,
    ICON_220                      = 220,
    ICON_221                      = 221,
    ICON_222                      = 222,
    ICON_223                      = 223,
    ICON_224                      = 224,
    ICON_225                      = 225,
    ICON_226                      = 226,
    ICON_227                      = 227,
    ICON_228                      = 228,
    ICON_229                      = 229,
    ICON_230                      = 230,
    ICON_231                      = 231,
    ICON_232                      = 232,
    ICON_233                      = 233,
    ICON_234                      = 234,
    ICON_235                      = 235,
    ICON_236                      = 236,
    ICON_237                      = 237,
    ICON_238                      = 238,
    ICON_239                      = 239,
    ICON_240                      = 240,
    ICON_241                      = 241,
    ICON_242                      = 242,
    ICON_243                      = 243,
    ICON_244                      = 244,
    ICON_245                      = 245,
    ICON_246                      = 246,
    ICON_247                      = 247,
    ICON_248                      = 248,
    ICON_249                      = 249,
    ICON_250                      = 250,
    ICON_251                      = 251,
    ICON_252                      = 252,
    ICON_253                      = 253,
    ICON_254                      = 254,
    ICON_255                      = 255
end type

public constant RAYGUI_ICON_SIZE = 16,
				RAYGUI_ICON_MAX_ICONS = 256,
				RAYGUI_ICON_MAX_NAME_LENGTH = 32
				
public constant RAYGUI_ICON_DATA_ELEMENTS = RAYGUI_ICON_SIZE * RAYGUI_ICON_SIZE / 32

public constant RAYGUI_MAX_CONTROLS = 16,
				RAYGUI_MAX_PROPS_BASE = 16,
				RAYGUI_MAX_PROPS_EXTENDED = 8
				
public enum type GuiPropertyElement
	BORDER = 0,
	BASE,
	TEXT,
	OTHER
end type

ifdef RAYGUI_STANDALONE then
	public constant KEY_RIGHT = 262,
	   				KEY_LEFT = 263,
	   				KEY_DOWN = 264,
	   				KEY_UP = 265,
	   				KEY_BACKSPACE = 259,
	   				KEY_ENTER = 257
	   				
	public constant MOUSE_BUTTON_LEFT = 0
end ifdef
­800.9