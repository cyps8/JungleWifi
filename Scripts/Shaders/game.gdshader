shader_type canvas_item;

uniform vec3 target_colour : source_color;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec3 col = texture(screen_texture, SCREEN_UV).xyz;
	if (col.x < target_colour.x)
	{
		col.x = target_colour.x;
	}
	if (col.y < target_colour.y)
	{
		col.y = target_colour.y;
	}
	if (col.z < target_colour.z)
	{
		col.z = target_colour.z;
	}
    COLOR.xyz = col;
}