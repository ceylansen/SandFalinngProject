shader_type canvas_item;

uniform float speed = -0.5;

void vertex() {
	UV.y += speed * TIME;
}
