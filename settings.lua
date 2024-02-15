data:extend({
	{
		name = 'bt:allow_beacons',
		type = 'bool-setting',
		setting_type = 'startup',
		default_value = false,
		order = 'a',
	},
	{
		name = 'bt:allow_productivity',
		type = 'bool-setting',
		setting_type = 'startup',
		default_value = false,
		order = 'b',
	},
	{
		name = 'bt:lite_mode',
		type = 'bool-setting',
		setting_type = 'startup',
		default_value = true,
		order = 'c',
		hidden = true,
	},
})