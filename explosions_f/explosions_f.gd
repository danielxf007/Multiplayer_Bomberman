extends Node
class_name ExplosionF

var util_f: UtilFunctions = UtilFunctions.new()

func cell_content_can_be_destroyed(cell: Cell) -> bool:
	return cell.element.has_method("destroy")

func row_explosion(_range: Array, row_index: int,
matrix_of_cells: Array) -> Array:
	var cell: Cell
	var row_explosion_range: Array = []
	var indexes: Tuple
	for j in _range:
		indexes = Tuple.new(row_index, j)
		if self.util_f.is_inside_matrix(self.util_f.get_dimensions_matrix(
			matrix_of_cells), indexes):
			cell = matrix_of_cells[row_index][j]
			if cell.is_occupied():
				row_explosion_range.append(indexes)
				break
			if not cell.is_occupied():
				row_explosion_range.append(indexes)
			elif self.cell_content_can_be_destroyed(cell):
				row_explosion_range.append(indexes)
			elif not self.cell_content_can_be_destroyed(cell):
				return row_explosion_range
	return row_explosion_range

func column_explosion(_range: Array, column_index: int,
matrix_of_cells: Array) -> Array:
	var cell: Cell
	var column_explosion_range: Array = []
	var indexes: Tuple
	for i in _range:
		indexes = Tuple.new(i, column_index)
		if self.util_f.is_inside_matrix(self.util_f.get_dimensions_matrix(
			matrix_of_cells), indexes):
				cell = matrix_of_cells[i][column_index]
				if cell.is_occupied():
					column_explosion_range.append(indexes)
					break
				if not cell.is_occupied():
					column_explosion_range.append(indexes)
				elif self.cell_content_can_be_destroyed(cell):
					column_explosion_range.append(indexes)
				elif not self.cell_content_can_be_destroyed(cell):
					return column_explosion_range
	return column_explosion_range

func diagonal_explosions_types(explosion_type: int) -> Tuple:
	var movement_type: Tuple = Tuple.new(null, null)
	match explosion_type:
		0: 
			movement_type = Tuple.new(1, -1)
		1:
			movement_type = Tuple.new(-1, -1)
		2:
			movement_type = Tuple.new(-1, 1)
		3:
			movement_type = Tuple.new(1, 1)
	return movement_type

func diagonal_explosion(board_dimensions: Tuple, starting_point: Tuple,
explosion_type: int, matrix_of_cells: Array) -> Array:
	var indexes: Tuple
	var movement: Tuple = self.diagonal_explosions_types(explosion_type)
	var diagonal_explosion_range: Array = []
	var i = starting_point.first_element + movement.first_element
	var j = starting_point.second_element + movement.second_element
	var cell: Cell
	while (self.util_f.number_in_range(0, board_dimensions.first_element, i)
	and self.util_f.number_in_range(0, board_dimensions.second_element, j)):
		cell = matrix_of_cells[i][j]
		if not cell.is_occupied():
			indexes = Tuple.new(i, j)
			diagonal_explosion_range.append(indexes)
		elif self.cell_content_can_be_destroyed(cell):
			indexes = Tuple.new(i, j)
			diagonal_explosion_range.append(indexes)
		elif not self.cell_content_can_be_destroyed(cell):
			return diagonal_explosion_range
		i+= movement.first_element
		j+= movement.second_element
	return diagonal_explosion_range
