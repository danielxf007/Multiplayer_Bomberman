extends Node
class_name ExplosionF

var util_f: UtilFunctions = UtilFunctions.new()

func row_explosion(_range: Array, row_index: int,
matrix_of_cells: Array, board_dimensions: Tuple) -> Array:
	var cell: Cell
	var row_explosion_range: Array = []
	var indexes: Tuple
	for j in _range:
		indexes = Tuple.new(row_index, j)
		if self.util_f.is_inside_matrix(board_dimensions, indexes):
			cell = matrix_of_cells[row_index][j]
			if cell.is_occupied():
				row_explosion_range.append(indexes)
				break
			else:
				row_explosion_range.append(indexes)
	return row_explosion_range

func column_explosion(_range: Array, column_index: int,
matrix_of_cells: Array, board_dimensions: Tuple) -> Array:
	var cell: Cell
	var column_explosion_range: Array = []
	var indexes: Tuple
	for i in _range:
		indexes = Tuple.new(i, column_index)
		if self.util_f.is_inside_matrix(board_dimensions, indexes):
				cell = matrix_of_cells[i][column_index]
				if cell.is_occupied():
					column_explosion_range.append(indexes)
					break
				else:
					column_explosion_range.append(indexes)
	return column_explosion_range
