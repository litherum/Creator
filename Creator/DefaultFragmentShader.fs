#version 410
 
out vec4 color;

uniform float redChannel;
 
void main() {
	color = vec4(redChannel, 0.0, 0.0, 1.0);
}