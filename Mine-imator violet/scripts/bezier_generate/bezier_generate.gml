///bezier_generate(t, p1x, p1y)
/*
t is a value from 0-1 to find on the line between p0 and p3
p1 is the control points

returns array (x,y)
*/
var t   = argument0;
var p1x = argument1;
var p1y = argument2;
var p2x = argument3;
var p2y = argument4;
var j = 0;
var out_value_y = 0;
var PXA,PYA;
//Calculate the point
var px =    0; //first term
var py =    0;

for (var i = 0;i<=100;i+=1){
	var xt = i*0.01;
	var xt2 = xt*xt;
	var xt3 = xt*xt*xt;
	px = 3*(1-xt)*(1-xt)*xt * p1x + 3*(1-xt)*xt2 * p2x + xt3; 
	py = 3*(1-xt)*(1-xt)*xt * p1y + 3*(1-xt)*xt2 * p2y + xt3;
	PXA[i] = px;
	PYA[i] = py;
}
//Pack into an array
while (PXA[j]<t){
	j+=1;
}
PXA[0] = 0;
PYA[0] = 0;

//临近点间线性化

var delta_t = (t-PXA[j])

if(j < 100){
	var k = abs((PYA[j+1]-PYA[j])/(PXA[j+1]-PXA[j]));
	out_value_y = abs(k*delta_t + PYA[j]);
}
else{
	var k = abs((PYA[100]-PYA[j])/(PXA[100]-PXA[j]));
	out_value_y = 1;
}

return out_value_y