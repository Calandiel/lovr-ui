UI = require "ui/ui"
buf = "John"
win2pos = lovr.math.newMat4( 0.1, 1.3, -1.3 )
check1 = true
check2 = false
rb_idx = 1
counter = 0
slider_int_val = 0
slider_float_val = 0
window3_open = false
tab_bar_idx = 1
col_list_idx = 1
progress_value = 0
accumulator = 0
time_now = 0

-- Override only some colors
custom_theme =
{
	text = { 0.6, 0.5, 0.1 },
	window_bg = { 0.1, 0.1, 0.1 },
	button_bg = { 0.08, 0.08, 0.08 },
	list_bg = { 0.14, 0.14, 0.2 },
}
text1 = "Blah, blah, blah..."
some_list = { "fade", "wrong", "milky", "zinc", "doubt", "proud", "well-to-do",
	"carry", "knife", "ordinary", "yielding", "yawn", "salt", "examine", "historical",
	"group", "certain", "disgusting", "hum", "left", "camera", "grey", "memorize",
	"squalid", "second-hand", "domineering", "puzzled", "cloudy", "arrogant", "flat" }

function lovr.load()
	UI.Init()
	lovr.graphics.setBackgroundColor( 0.4, 0.4, 1 )
	col_list = UI.GetColorNames()
end

function lovr.update( dt )
	UI.InputInfo()
	accumulator = accumulator + (10 * dt)
	progress_value = math.floor( accumulator )
	if progress_value > 70 then
		progress_value = 0
		accumulator = 0
	end
end

function lovr.draw( pass )
	pass:setColor( .1, .1, .12 )
	pass:plane( 0, 0, 0, 25, 25, -math.pi / 2, 1, 0, 0 )
	pass:setColor( .2, .2, .2 )
	pass:plane( 0, 0, 0, 25, 25, -math.pi / 2, 1, 0, 0, 'line', 50, 50 )

	UI.NewFrame( pass )

	local lh_pose = lovr.math.newMat4( lovr.headset.getPose( "hand/left" ) )
	lh_pose:rotate( -math.pi / 2, 1, 0, 0 )
	UI.Begin( "FirstWindow", mat4( -0.5, 1.4, -1 ) )
	if UI.ImageButton( "ui/lovrlogo.png" ) then print( "imagebutton" ) end
	UI.SameLine()
	UI.Label( "<- An ImageButton" )

	local old_buf = buf
	local got_focus, buffer_changed, textbox_id
	got_focus, buffer_changed, textbox_id, buf = UI.TextBox( "Name", 6, buf ) -- Mutate original string
	if got_focus then
		print( "got focus" )
	end
	if buffer_changed then
		print( "Old text was: " .. "'" .. old_buf .. "'" .. ", new text is: " .. "'" .. buf .. "'" )
		-- Do text validation here. If it fails your rules (invalid character, text length too long. etc.) then you can set the text to a 'valid' value as follows:
		-- UI.SetTextBoxText( textbox_id, "My new text" )
	end
	UI.TextBox( "Profession", 20, "" )
	if UI.Button( "Test", 0, 0 ) then
		print( buf )
	end
	UI.SameLine()
	UI.Button( "SameLine()" )
	if UI.Button( "Times clicked: " .. counter ) then
		counter = counter + 1
	end
	UI.SameLine()
	if UI.CheckBox( "Really?", check1 ) then
		check1 = not check1
	end
	UI.Label( "Hello world in Greek: Γεια σου κόσμε!" )
	local s1, s2
	s1, slider_int_val = UI.SliderInt( "SliderInt", slider_int_val, -100, 100, 400 )
	s2, slider_float_val = UI.SliderFloat( "SliderFloat", slider_float_val, -100, 100, 400, 3 )
	UI.Label( "Some list of things:" )
	local list_clicked, list_selected_idx = UI.ListBox( "Somelistbox", 15, 20, some_list )
	if list_clicked then
		print( list_selected_idx )
	end
	UI.SameLine()
	if UI.Button( "Delete" ) then table.remove( some_list ) end
	if UI.RadioButton( "Radio1", rb_idx == 1 ) then
		rb_idx = 1
	end
	if UI.RadioButton( "Radio2", rb_idx == 2 ) then
		rb_idx = 2
	end
	if UI.RadioButton( "Radio3", rb_idx == 3 ) then
		rb_idx = 3
	end
	UI.End( pass )

	UI.Begin( "SecondWindow", win2pos )
	UI.TextBox( "Location", 20, "" )
	if UI.Button( "AhOh" ) then print( UI.GetWindowSize( "FirstWindow" ) ) end
	UI.Label( "Energy bill increase:" )
	UI.ProgressBar( progress_value, 400 )
	UI.Button( "Forced height", 0, 200 )
	UI.Button( "Forced width", 400 )

	if UI.CheckBox( "Check Me", check2 ) then
		check2 = not check2
	end

	if UI.Button( "Toggle another window opened/closed\nattached to your left hand" ) then
		window3_open = not window3_open
	end
	UI.End( pass )

	if window3_open then
		UI.Begin( "ThirdWindow", lh_pose )
		UI.ImageButton( "ui/lovrlogo.png", 32, 32 )
		UI.Label( "Operating System: " .. lovr.system.getOS() )
		UI.Label( "User Directory: " .. (lovr.filesystem.getUserDirectory() or 'N/A') )
		UI.Label( "Average Delta: " .. string.format( "%.6f", lovr.timer.getAverageDelta() ) )
		if UI.Button( "Close Me" ) then
			window3_open = false
		end
		UI.End( pass )
	end

	UI.Begin( "TabBar window", mat4( -0.9, 1.4, -1 ) )
	local was_clicked, idx = UI.TabBar( "my tab bar", { "first", "second", "third" }, tab_bar_idx )
	if was_clicked then
		tab_bar_idx = idx
	end
	if tab_bar_idx == 1 then
		UI.Button( "Button on 1st tab" )
		UI.Label( "Label on 1st tab" )
		UI.Label( "LÖVR..." )
	elseif tab_bar_idx == 2 then
		UI.Button( "Button on 2nd tab" )
		UI.Label( "Label on 2nd tab" )
		UI.Label( "is..." )
	elseif tab_bar_idx == 3 then
		UI.Button( "Button on 3rd tab" )
		UI.Label( "Label on 3rd tab" )
		UI.Label( "awesome!" )
	end
	UI.End( pass )

	-- color tweaker test
	UI.Begin( "Color editor window", mat4( 0.5, 1.2, -1.3 ) )
	UI.Label( "Color editor" )
	local button_bg_color = UI.GetColor( "button_bg" )
	local text_color = UI.GetColor( "text" )

	UI.OverrideColor( "text", { 0, 0, 0 } )
	UI.OverrideColor( "button_bg", { 1, 0, 0 } )
	UI.Button( "Override" )
	UI.SameLine()

	UI.OverrideColor( "text", { 0, 0, 0 } )
	UI.OverrideColor( "button_bg", { 0, 1, 0 } )
	UI.Button( "some" )
	UI.SameLine()

	UI.OverrideColor( "text", { 1, 1, 1 } )
	UI.OverrideColor( "button_bg", { 0, 0, 1 } )
	UI.Button( "colors" )

	UI.OverrideColor( "button_bg", button_bg_color )
	UI.OverrideColor( "text", text_color )
	UI.Label( "Set theme:" )
	if UI.Button( "Dark" ) then
		UI.SetColorTheme( "dark" )
	end
	UI.SameLine()
	if UI.Button( "Light" ) then
		UI.SetColorTheme( "light" )
	end
	UI.SameLine()
	if UI.Button( "Custom..." ) then
		UI.SetColorTheme( custom_theme, "dark" )
	end

	local val = UI.GetColor( col_list[ col_list_idx ] )
	if val then
		local rdown, gdown, bdown
		r_released, val[ 1 ] = UI.SliderFloat( "R", val[ 1 ], 0, 1, 600, 3 )
		g_released, val[ 2 ] = UI.SliderFloat( "G", val[ 2 ], 0, 1, 600, 3 )
		b_released, val[ 3 ] = UI.SliderFloat( "B", val[ 3 ], 0, 1, 600, 3 )
		if r_released or g_released or b_released then
			UI.SetColor( col_list[ col_list_idx ], { val[ 1 ], val[ 2 ], val[ 3 ] } )
		end
	end
	if UI.Button( "Print to output" ) then
		local t = {}
		print( "my_colors = {" )
		for i, v in ipairs( col_list ) do
			local val = UI.GetColor( col_list[ i ] )
			t[ i ] = val
			print( col_list[ i ] ..
				" = " .. "{" .. string.format( "%.3f", t[ i ][ 1 ] ) .. ", " .. string.format( "%.3f", t[ i ][ 2 ] ) .. ", " .. string.format( "%.3f", t[ i ][ 3 ] ) .. "}," )
		end
		print( "}" )
	end
	col_list_idx = select( 2, UI.ListBox( "color list", 10, 30, col_list ) )
	UI.End( pass )

	UI.RenderFrame( pass )
	return true
end
