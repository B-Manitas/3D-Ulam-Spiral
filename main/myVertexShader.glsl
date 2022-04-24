uniform mat4 modelview;
uniform mat4 transform;

attribute vec4 position;

attribute vec4 vert_color;
varying vec4 vertColor;

void main() {
  gl_Position = transform * position;
  vertColor = vert_color;
}