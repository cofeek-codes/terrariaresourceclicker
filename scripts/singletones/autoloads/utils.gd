extends Node

func _round_decimal(value: float, decimal_places: int) -> float:
	var factor = pow(10, decimal_places)
	return round(value * factor) / factor

# Function to abbreviate numbers (e.g., 1,234,567 -> 1.23M)
func abbreviate_number(num: float) -> String:
	var abs_num = abs(num)
	var suffix = ""
	var value = num

	if abs_num >= 1_000_000_000:
		value = num / 1_000_000_000.0
		suffix = "B"
	elif abs_num >= 1_000_000:
		value = num / 1_000_000.0
		suffix = "M"
	elif abs_num >= 1_000:
		value = num / 1_000.0
		suffix = "K"
	else:
		return str(num)

	value = _round_decimal(value, 2)
	return str(value) + suffix
