extends ItemList

var data = [];
var time = 0;

func _ready():
	pass

func _process(delta):
	time += 50*delta;
	if (time > 250):
		self.add_item("you got another email!")
		time = 0
