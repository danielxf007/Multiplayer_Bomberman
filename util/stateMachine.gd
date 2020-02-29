extends Node
signal state_changed(new_state)
class_name Machine
export(Dictionary) var states_map: Dictionary = {} #Contains node paths
export(NodePath) var INITIAL_STATE: NodePath
const front_position: int = 0
var states_stack: Array = [] #Constains nodes
var _active: bool = false

func _ready():
	if self.states_map.empty() or self.get_children().empty():
		self.set_active(false)
	else:
		self.set_active(true)
		for child in self.get_children():
			child.connect("finished", self, "_change_state")
		if not self.INITIAL_STATE:
			self.set_initial_state(self.get_child(self.front_position).get_path())
		self.states_stack.push_front(self.get_node(self.INITIAL_STATE))
		self.get_current_state().enter()
		emit_signal("state_changed", self.get_current_state().name)

func set_initial_state(new_state: NodePath) -> void:
	self.INITIAL_STATE = new_state

func set_states_map(new_states_map: Dictionary) -> void:
	self.states_map = new_states_map

func set_active(value: bool) -> void:
	self._active = value
	if not self._active:
		self.states_stack = []

func get_current_state() -> State:
	if not self.states_stack.empty():
		return self.states_stack[self.front_position]
	else:
		return null

func has_greater_priority(state_name : String) -> bool:
	return self.get_current_state().priority < self.get_node(self.states_map[state_name]).priority

func has_same_priority(state_name : String) -> bool:
	return self.get_current_state().priority == self.get_node(self.states_map[state_name]).priority

func update_active(value: bool) -> void:
	self._active = value

func turn_on_off(value: bool) -> void:
	self._active = value

func _change_state(state_name: String) -> void:
	if self._active and not self.states_stack.empty():
		if state_name != "previous":
			if self.has_greater_priority(state_name):
				self.get_current_state().exit()
				self.states_stack.push_front(self.get_node(self.states_map[state_name]))
				self.get_current_state().enter()
				emit_signal("state_changed", state_name)
			elif self.has_same_priority(state_name):
				self.get_current_state().exit()
				self.states_stack.pop_front()
				self.states_stack.push_front(self.get_node(self.states_map[state_name]))
				self.get_current_state().enter()
				emit_signal("state_changed", state_name)
		else:
			self.get_current_state().exit()
			self.states_stack.pop_front()
			self.emit_signal("state_changed", self.get_current_state().name)
