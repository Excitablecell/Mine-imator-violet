/// view_shape_spotlight(timeline)
/// @arg timeline
/// @desc Renders a spotlight shape.

var tl, points;
tl = argument0

// Sphere
view_shape_circle(tl.world_pos, 2)

// Cone
points = array(
	point3D(-2, -3, -2),
	point3D(-2, -3, 2),
	point3D(2, -3, -2),
	point3D(2, -3, 2),
	point3D(-4, 6, -4),
	point3D(-4, 6, 4),
	point3D(4, 6, -4),
	point3D(4, 6, 4)
)
view_shape_draw(points, tl.matrix)
