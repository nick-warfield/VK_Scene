// Vertex Shader
#version 450

vec2 positions[3] = vec2[](
	vec2(0.0, -0.5),
	vec2(0.5, 0.5),
	vec2(-0.5, 0.5)
);

void main() {
	gl_position = vec4(positions[gl_VertexIndex], 0.0, 1.0);
}
