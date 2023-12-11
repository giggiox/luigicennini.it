---
title: "Bézier curves and patches - interactive visualization"
date: 2023-10-01T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - Rich content
  - Sample
  - example
image: /projects/bezier/copertina9.png
description: ""
toc: true
mathjax: true
---

# Bézier Curves


Bézier curves are a fundamental concept in computer graphics and vector drawing. They are used to describe curves by controlling points called 'control points'. 
These curves were introduced by Pierre Bézier in the 1960s as a method of representing curves on computer screens.
A Bézier curve has the form


$$\underline{x}(t) = \sum_{i=0}^n \underline{b}_i B_i^n(t), t\in[0,1]$$

Where,

$$B_i^n(t) = {n \choose i}t^i(1-t)^{n-i}, i= 0,...,n$$

are the n+1 basic Bernstein polynomials.


NIn the editor below, I have implemented an interactive version of these curves.
The algorithms I have implemented are the curve computation algorithm or the **de Casteljau algorithm** and the degree elevation algorithm.


Editor instructions:
- 2 left-clicks to add a new control point
- move control points by dragging while holding down the left mouse button
- right-click repeatedly to remove control polygon and interpolation scheme


{{< rawhtml >}} 
<script src="/p5.min.js"></script>
<script src="/math.js"></script>
{{< /rawhtml >}}



{{< rawhtml >}} 
<div id ="firstCanvas"></div>




<script>
//TODO TUTTO QUESTO E DA RIGUARDARE SERVE PER FARE IL LOAD E L'UNLOAD DEI CANVAS, PER AVERE PERFORMANCE MIGLIORI
/**let sketchLoaded = false;
window.addEventListener('scroll', checkScroll);

function checkScroll() {
      let scrollY = window.scrollY || window.pageYOffset || document.documentElement.scrollTop;

      let triggerY = document.getElementById("secondCanvas").offsetTop - screen.height;

      // Se lo scroll supera la coordinata triggerY e lo sketch non è ancora stato caricato, caricalo
      if (scrollY > triggerY && !sketchLoaded) {
		console.log("arrivato")
        
		//new p5(secondSketch,"secondCanvas");
		sketchLoaded = true;
        // Chiamare la funzione che inizializza il tuo sketch p5.js
        
      } else if (scrollY <= triggerY && sketchLoaded) {
        // Altrimenti, se lo scroll è prima della coordinata triggerY e lo sketch è caricato, esegui il "unload"
        //unloadSketch();
		sketchLoaded = false;
      }
}
**/

</script>

{{< /rawhtml >}}























**Warning**: If you are not correctly seeing (or not seeing) the sketch below correctly, visit [this link](https://editor.p5js.org/giggiox/full/nyiLHZ80x). Or [this link](https://editor.p5js.org/giggiox/sketches/nyiLHZ80x) to see and edit the source code.

{{< rawhtml >}} 





<div id ="thirdCanvas" ></div>

<div class="container text-center" id="forWidth">
	<div class="row">
			
		<div class="col-sm-5 col-md-6" id ="sliderCol3">
		t
		</div>
		
		<div class="col-sm-5 offset-sm-2 col-md-6 offset-md-0" id ="granularity3">
		granularity
		</div>
		
	</div>
</div>
<div class="container text-center">
	<div class="row">
		<div class="col-sm-5 col-md-6">
			auto play
			<br>
			<div class="checkbox-wrapper-6" id="autoPlay3" style="display: inline-block;">
			  <input class="tgl tgl-light" id="cb1-6" type="checkbox" />
			  <label class="tgl-btn" for="cb1-6">
			</div>
			
		</div>
		<div class="col-sm-5 offset-sm-2 col-md-6 offset-md-0">
			<button class="button button2" id="degreeElevation3">degree elevation</button>
		</div>
	</div>
</div>


<script>
var secondSketch = function(sketch){

	var bezierCurve;
	var slider; var sliderMax = 100;
	var checkBoxAutoPlay;  let checkedBoxAutoPlay = false;let addToSlider = 1;
	var checkBoxShowConstructLines;
	var checkBoxShowControlPolygonLines;
	var checkBoxShowCurveTrace;
	var checkBoxShowConstructPoints;
	var granularity,button,button1;

	var canvasResizeFactor = 1.6;

	sketch.setup = function(){
		bezierCurve = new BezierCurve([[sketch.windowWidth/canvasResizeFactor/1.5,sketch.windowHeight/canvasResizeFactor/3],
										[sketch.windowWidth/canvasResizeFactor/4,sketch.windowHeight/canvasResizeFactor/1.1]]);
		sketch.frameRate(160); //change this for the slider autoplay velocity
	
	
		let width = document.getElementById("forWidth").offsetWidth;
		var myCanvas = sketch.createCanvas(width, sketch.windowHeight/1.6);
		/* check for double click since p5js does not offer a Canvas.mouseDoubleClick but only a canvas.mouseClick. Using the function doubleClicked of p5js does not work because it's global and with more than 1 canvas on a page it gets mad */
		document.getElementById("thirdCanvas").addEventListener('dblclick', doubleClick);
		
		document.getElementById("thirdCanvas").addEventListener('contextmenu',leftClick);
		document.getElementById('thirdCanvas').addEventListener('contextmenu',event => event.preventDefault()); //remove the window menu for right click
		
		slider = sketch.createSlider(0, sliderMax, 1);
		slider.parent("sliderCol3");
		slider.addClass("myslider");
		slider.value(sliderMax);
		
		granularity = sketch.createSlider(10, 500, 400);
		granularity.addClass("myslider");
		granularity.parent("granularity3");
		
		
		document.getElementById("autoPlay3").addEventListener('change',myEventCheckBoxAutoPlay);
		document.getElementById("degreeElevation3").addEventListener('click',myEventDegreeElevation);

	}

	sketch.draw = function() {
		//sketch.clear();
		//sketch.background(220, 10);
		sketch.background(250);
		bezierCurve.changeGranularity(granularity.value());
		if(checkedBoxAutoPlay){
			if(slider.value() == sliderMax) addToSlider = -1;
			if(slider.value() == 0 && addToSlider < 0 ) addToSlider = 1;
			slider.value((slider.value()+addToSlider)); 
		}
		bezierCurve.render(); 
	}
	
	
	
	
	class ConstructLine{
	  
	  constructor(p1 = null,p2 = null) {
		this.p1 = p1;
		this.p2 = p2;
		
	  }
	  render() {
			//stroke(126);
			sketch.strokeWeight(1.5);
			sketch.line(this.p1.x,this.p1.y,this.p2.x,this.p2.y);
	  }
	  
	}
	

	
	function mapSpace(x,in_min, in_max,out_min,out_max) {
		return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
	}

	function linspace(startValue, stopValue, cardinality) {
		var arr = [];
		var step = (stopValue - startValue) / (cardinality - 1);
		for (var i = 0; i < cardinality; i++) {
			arr.push(startValue + (step * i));
		}
		return arr;
	}
	
	class BezierCurve{
	  constructor(points = []) {
		//TODO add the possibility to create a curve passing arguments
		
		
		this.controlPoints = [];
		this.draggedControlPointIndex = -1; // by convention = -1 if we are not dragging any point
		
		this.controlPointsX = [];
		this.controlPointsY = [];
		
		this.granularity = 1000;
		this.t = linspace(0,1,this.granularity);
		
		this.constructLines = [];
		this.constructPoints = [];
		this.controlPolygonLines = [];
		
		this.checkedShowControlPolygon = true;
		this.checkedShowConstructLines = true;
		this.checkedShowCurveTrace = true;
		this.checkedShowConstructPoints = true;
		
		
		if(points.length != 0){
			for(let i = 0; i<points.length; i++){
				this.addControlPoint(points[i][0],points[i][1]);
			}
		}
		
		
		
		
		
	  }
	  
	  
	  degreeElevation(){
		let lastX, lastY, n;
		n = this.controlPoints.length-1;
		lastX = this.controlPoints[n].x;
		lastY = this.controlPoints[n].y;
		//cant do in place because changing b_i in one iteration then the next cant retrive true b_i value
		//using duplicate copys of coordinates (required extra loop) to do it easily
		
		for(let i = 1; i <= n; i++){
		  this.controlPoints[i].x = i/(n+1) * this.controlPointsX[i-1] + (n-i+1)/(n+1)*this.controlPointsX[i];
		  this.controlPoints[i].y = i/(n+1) * this.controlPointsY[i-1] + (n-i+1)/(n+1)*this.controlPointsY[i];
		  
		}
		for(let i=0;i<=n; i++){
		  this.controlPointsX[i] = this.controlPoints[i].x;
		  this.controlPointsY[i] = this.controlPoints[i].y;
		}
		this.addControlPoint(lastX,lastY);
		
		
	  }
	  
	  changeGranularity(x){
		this.granularity = x;
		this.t = linspace(0,1,x);
	  }
		
	  
		
		
	  addControlPoint(x,y){
		this.controlPoints.push(new ConstructPoint(x,y,6));
		this.controlPointsX.push(x);
		this.controlPointsY.push(y);
		
		
		let n = this.controlPoints.length;
		
		//number of constructPoint (interpolating points) goes as triangular sequence
		//0,1,3,6,10,15,... = n(n+1)/2
		//for n= 0 (1 control points) -> 0 interpolating points
		//for n= 1 (2 control points)-> 1 interpolating points
		//for n= 2 (3 control points) -> 3 interpolating points
		//for n = 3 (4 control points) -> 6 interpolating points
		//and so on
		for(let i = 0; i < (n*(n+1)/2 - this.constructPoints.length)-1;i++){
		  this.constructPoints.push(new ConstructPoint(x,y));
		}
		
		
		//number of constructLines goes as triangular sequence but with n-1 so (n-1)*(n)/2
		//for n= 0 (1 control points) -> 0 interpolating lines
		//for n= 1 (2 control points)-> 0 interpolating lines
		//for n= 2 (3 control points) -> 1 interpolating lines
		//for n = 3 (4 control points) -> 3 interpolating lines
		//for n = 4 (5 control points) -> 6 interpolating lines
		//and so on
		for(let i = 0; i< ((n-1)*n/2 - this.constructLines.length)-1; i++){
		  this.constructLines.push(new ConstructLine(this.controlPoints[this.controlPoints.length-2],this.controlPoints[this.controlPoints.length-3]));
		}
		
		

		//add Control polygon lines
		if(n>1){
		  this.controlPolygonLines.push(new ConstructLine(this.controlPoints[this.controlPoints.length-2],this.controlPoints[this.controlPoints.length-1]));
		}
		
		
		
	  }
	  
	  showConstructPoints(){
		this.checkedShowConstructPoints = !this.checkedShowConstructPoints;
	  }
	  
	  //change visibility of the control polygon
	  showControlPolygon(){
		this.checkedShowControlPolygon = !this.checkedShowControlPolygon;
	  }
	  //change visibility of construct lines (interpolating lines)
	  showConstructLines(){
		this.checkedShowConstructLines = !this.checkedShowConstructLines;
	  }
	  
	  //change visibility of curve trace
	  showCurveTrace(){
		this.checkedShowCurveTrace = ! this.checkedShowCurveTrace;
	  }
	  
	  //calculate de casteljau algorithm
	  calcBezierPoint(t){
		
		if(this.controlPoints.length == 0){ return null; }
		
		//copy control points coordinate because with them moving, can't make 
		//in place replace
		let controlPointsXCopy = [...this.controlPointsX]; 
		let controlPointsYCopy = [...this.controlPointsY];
		let k = 0; let m = 0;
		for(let i = 0; i< this.controlPoints.length-1; i++){
		  for(let j = 0; j<this.controlPoints.length-i-1; j++){
			controlPointsXCopy[j] = (1-t)*controlPointsXCopy[j] + t*controlPointsXCopy[j+1];        
			controlPointsYCopy[j] = (1-t)*controlPointsYCopy[j] + t*controlPointsYCopy[j+1];

			
			
			this.constructPoints[k].x = controlPointsXCopy[j];
			this.constructPoints[k].y = controlPointsYCopy[j];
			
			if(j>0){
			  this.constructLines[m].p1 = this.constructPoints[k];
			  this.constructLines[m].p2 = this.constructPoints[k-1];
			  m+=1;
			}
			
			k += 1;
		  }
		}
		return [controlPointsXCopy[0], controlPointsYCopy[0]]
		
	  }
	  
	  mousePressedAction(){
		for (let i = 0; i < this.controlPoints.length; i++) {
		  let vertexUI = this.controlPoints[i];
		  
		  if(vertexUI.hasInside(sketch.mouseX,sketch.mouseY)){
			this.draggedControlPointIndex = i;
		  }
		}
		
	  }
	  
	  mouseDraggedAction(){
		if (this.draggedControlPointIndex == -1)
				return;
		let newMouseX = sketch.mouseX;
		let newMouseY = sketch.mouseY;
		
		this.controlPoints[this.draggedControlPointIndex].x = newMouseX;
		this.controlPoints[this.draggedControlPointIndex].y = newMouseY;
		this.controlPointsX[this.draggedControlPointIndex] = newMouseX;
		this.controlPointsY[this.draggedControlPointIndex] = newMouseY;
		
	  }
	   mouseReleasedAction() {
			this.draggedControlPointIndex = -1;
		}
	  
	  
	  render(){
		
		
	  
		for(let i = 0; i < this.controlPoints.length; i++){
		  this.controlPoints[i].render();
		}
		
		
		//commented because this draws the whole curve without accounting the slider
		/*for(let i = 0; i< this.t.length; i++){
		  
		  let tmp = this.calcBezierPoint(this.t[i]);
		  if(tmp != null){
			//console.log(tmp[0] + "  " + tmp[1]);
			stroke(0);
			strokeWeight(2);
			ellipse(tmp[0],tmp[1], 1, 1);
		  }
		}*/
		
		//the slider.value() != 0 removes imperfections in visualization. (overlapping lines or points not returning to the begininning)
		if(this.checkedShowConstructPoints && slider.value() != 0 && slider.value() != sliderMax){
		  for(let i = 0; i< this.constructPoints.length; i++){
			this.constructPoints[i].render();
		  }
		}
		
		if(this.checkedShowConstructLines && slider.value() != 0 && slider.value() != sliderMax){
		  for(let i = 0; i< this.constructLines.length; i++){
			this.constructLines[i].render();
		  }
		}
		
		if(this.checkedShowControlPolygon){
		  for(let i = 0; i< this.controlPolygonLines.length; i++){
			this.controlPolygonLines[i].render();
		  }
		}
	  
	  
		
		for(let i = 0; i< mapSpace(slider.value(),0,100,0,this.granularity); i++){
		  let tmp = this.calcBezierPoint(this.t[i]);
		  if(tmp != null &&  this.checkedShowCurveTrace){
			sketch.strokeWeight(1.5);
			sketch.stroke("blue");
			sketch.point(tmp[0],tmp[1]);
		  }
		}
	  }
	}
	
	
	
	class ConstructPoint{
		constructor(x = null, y = null,radius = 3) {
			this.x = x;
			this.y = y;
			this.radius = radius;
			this.grabbableRadius = radius + 4;
		}
		render() {
			sketch.stroke(0);
			sketch.strokeWeight(5);
			sketch.ellipse(this.x,this.y, this.radius, this.radius);
		}  
		
		/**
		hasInside only used for a point that is a bezier control point. We need to know if the mouse is inside in order to move it.
		
		**/
		hasInside(x, y) {
			let distance = sketch.dist(this.x, this.y, x, y);
			return distance <= this.grabbableRadius; 
			
		}
	}
	
	function doubleClick(){
		bezierCurve.addControlPoint(sketch.mouseX,sketch.mouseY);
	}
	
	sketch.mousePressed = function(){
	  bezierCurve.mousePressedAction();
	}

	sketch.mouseDragged = function(){
	  bezierCurve.mouseDraggedAction();
	}

	sketch.mouseReleased = function(){
	  bezierCurve.mouseReleasedAction()
	}
	
	sketch.windowResized = function(){ 
		let width = document.getElementById("forWidth").offsetWidth;
		sketch.resizeCanvas(width,sketch.widowHeight/1.6);
	}
	
	function myEventCheckBoxAutoPlay(){
	  checkedBoxAutoPlay = !checkedBoxAutoPlay;
	}
	
	function myEventCheckBoxShowControlPolygonLines(){
	  bezierCurve.showControlPolygon();
	}
	
	function myEventCheckBoxShowConstructLines(){
	  bezierCurve.showConstructLines();
	}

	function myEventCheckBoxShowCurveTrace(){
	  bezierCurve.showCurveTrace();
	}

	function myEventDegreeElevation(){
	  bezierCurve.degreeElevation();
	}

	function myEventChangeGranularity(){
	  bezierCurve.changeGranularity(granularity.value());
	}
	function myEventCheckBoxShowConstructPoints(){
		bezierCurve.showConstructPoints();
	}
	
	
	var clickNum = 0;
	function leftClick(){
		clickNum += 1;
		if(clickNum == 1){
			bezierCurve.showConstructLines();
			bezierCurve.showConstructPoints()
		}
		if(clickNum == 2){
			bezierCurve.showControlPolygon();
			clickNum = 0;
		}
	}

}
new p5(secondSketch,"thirdCanvas");


</script>



<style>

canvas {

  border-radius: 30px;
}
</style>

{{< /rawhtml >}}








<br />
<br />
	
##  De Casteljau Algorithm
De Casteljau's algorithm is a stable iterative method for calculating points on a Bézier curve.
The algorithm works like this:
$$\underline{b}_i^0(t) = \underline{b}_i$$
$$\underline{b}_i^r(t) = (1-t)\underline{b}_i^{r-1}(t)+t\underline{b}_k^{r-1}(t)$$
$$k=i+1;r=1,...,n; i=0,...,n-r$$

Where $$\underline{b}_0^n(t) = \underline{x}(t)$$ is the point on the Bézier curve associated with the value of the parameter t.



## Degree elevation Algorithm
The degree elevation algorithm transforms a Bézier curve of degree n into a Bézier curve of degree n+1:

$$\underline{x}(t)=\sum_{i=0}^n \underline{b}_i B_i^n(t)$$

$$= \sum_{i=0}^{n+1} \underline{c}_i B_i^{n+1}(t)$$

in this way:

$$ \underline{c}_i= \frac{i}{n+1} \underline{b}_k + \frac{n-i+1}{n+1}\underline{b}_i; k = i-1; i=1,...,n$$


$$\underline{c}_0=\underline{b}_0,\underline{c}_m=\underline{b}_n; m = n+1$$








# 3-dimensional Bézier curve

In the editor above, the control points of the bezier curve are control points in 2 dimensions.
Namely, 
$$\underline{b}_i = { b_x \choose b_y}$$

However, all the algorithms seen above also work for three-dimensional curves, where the control points will also have a z component. All the algorithms therefore remain unchanged,


**Warning**: If you are not correctly seeing (or not seeing) the sketch below correctly, visit [this link](https://editor.p5js.org/giggiox/full/-UfZh9jUd). Or [this link](https://editor.p5js.org/giggiox/sketches/-UfZh9jUd) to see and edit the source code.

{{< rawhtml >}} 
<div id ="fourthCanvas" ></div>

<div class="container text-center">
	<div class="row">
		<div class="col-sm-5 col-md-6" id ="sliderCol">
		t
		</div>
		
		<div class="col-sm-5 offset-sm-2 col-md-6 offset-md-0">
			auto play
			<br>
			<div class="checkbox-wrapper-6" id="autoPlay" style="display: inline-block;">
			  <input class="tgl tgl-light" id="cb1-6-3" type="checkbox" />
			  <label class="tgl-btn" for="cb1-6-3">
			</div>
		</div>
	</div>
</div>


<script>
var fourthSketch = function(sketch){

	var bezierCurve;
	var slider; var sliderMax = 100;
	var checkBoxAutoPlay;  let checkedBoxAutoPlay = false;let addToSlider = 1;
	var checkBoxShowConstructLines;
	var checkBoxShowControlPolygonLines;
	var chhckBoxShowCurveTrace;
	var granularity,button,button1;
	var canvasResizeFactor = 1.6;
	
	
	let addedListener = true;


	sketch.setup = function(){		
		bezierCurve = new BezierCurve([[130,130,-20],[-110,80,-100],[20,-90,-20],[20,45,105]]);
		
		
		sketch.frameRate(60); //change this for the slider autoplay velocity
	
		let width = document.getElementById("forWidth").offsetWidth;
		var myCanvas = sketch.createCanvas(width, sketch.windowHeight/1.6,sketch.WEBGL);
		
		cam2 = sketch.createCamera()
		
		
		sketch.colorMode(sketch.HSB);
		sketch.angleMode(sketch.DEGREES);
		sketch.stroke(0,0,0);
		sketch.strokeWeight(4);
		
		slider = sketch.createSlider(0, sliderMax, 1);
		slider.parent("sliderCol");
		slider.addClass("myslider");
		slider.value(sliderMax);
		document.getElementById("autoPlay").addEventListener('change',myEventCheckBoxAutoPlay);
		document.getElementById("fourthCanvas").addEventListener('contextmenu',leftClick);
		document.getElementById("fourthCanvas").addEventListener('contextmenu',event => event.preventDefault()); //remove the window menu for right click
		document.getElementById("fourthCanvas").addEventListener('dblclick', doubleClick);
		
	}

	sketch.draw = function() {
		sketch.background(250);
		
		// Pan: Cam rotation about y-axis (Left Right)
		let azimuth = -sketch.atan2(cam2.eyeZ - cam2.centerZ, cam2.eyeX - cam2.centerX);
	  
		// Tilt: Cam rotation about z-axis (Up Down)
		let zenith = -sketch.atan2(cam2.eyeY - cam2.centerY, sketch.dist(cam2.eyeX, cam2.eyeZ, cam2.centerX, cam2.centerZ));
	  
		// f is a scaling factor (depends on canvas size and camera perspective settings)
		let f = sketch.height * 4.3 / 5;
		let x = [-1, (sketch.mouseY - sketch.height/2)/f, -(sketch.mouseX - sketch.width/2)/f]
	  
		let R = math.multiply(Rz(-zenith), Ry(azimuth))
		x = math.multiply(x, R)

		let xMag = sketch.dist(0, 0, 0, x._data[0], x._data[1], x._data[2])
		
		let objSelected = false;
	  
		for(let i = 0; i < bezierCurve.controlPoints.length; i++){
			let dToObj = sketch.dist(cam2.eyeX, cam2.eyeY, cam2.eyeZ, bezierCurve.controlPoints[i].x, bezierCurve.controlPoints[i].y, bezierCurve.controlPoints[i].z);
			if(sketch.dist(cam2.eyeX + x._data[0] * dToObj / xMag, cam2.eyeY + x._data[1] * dToObj / xMag, cam2.eyeZ + x._data[2] * dToObj / xMag, bezierCurve.controlPoints[i].x, bezierCurve.controlPoints[i].y, bezierCurve.controlPoints[i].z) < 20) {
				let canMove =  true;
				for(let j=0;j<bezierCurve.controlPoints.length;j++){
					if(i!=j && bezierCurve.controlPoints[j].selected) canMove = false;
				}
 
				if(sketch.mouseIsPressed  && canMove){
					objSelected = true;
					bezierCurve.controlPoints[i].selected = true;
					
					bezierCurve.controlPoints[i].x = cam2.eyeX + x._data[0] * dToObj / xMag; 
					bezierCurve.controlPointsX[i] = bezierCurve.controlPoints[i].x;
					bezierCurve.controlPoints[i].y = cam2.eyeY + x._data[1] * dToObj / xMag; 
					bezierCurve.controlPointsY[i] = bezierCurve.controlPoints[i].y;
					bezierCurve.controlPoints[i].z = cam2.eyeZ + x._data[2] * dToObj / xMag;
					bezierCurve.controlPointsZ[i] = bezierCurve.controlPoints[i].z; 
				}else{
					bezierCurve.controlPoints[i].selected = false;
					objSelected = false;
				}
			}
		}
		
		
		
		/**if(!objSelected && !addedListener){
			console.log("ciao");
			document.getElementById("fourthCanvas").addEventListener('click',sketch.orbitControl(4,4));
			addedListener = true;
		}else{
			document.getElementById("fourthCanvas").removeEventListener('click',sketch.orbitControl(4,4))
			addedListener = false;
		}**/
		if(!objSelected){
			sketch.orbitControl(4,4);
		}
		
		
		if(checkedBoxAutoPlay){
			if(slider.value() == sliderMax) addToSlider = -1;
			if(slider.value() == 0 && addToSlider < 0 ) addToSlider = 1;
			slider.value((slider.value()+addToSlider)); 
		}
		bezierCurve.render(); 
	}
	
	
	
	
	class ConstructLine{
	  
	  constructor(p1 = null,p2 = null) {
		this.p1 = p1;
		this.p2 = p2;
		
	  }
	  render() {
			//stroke(126);
			sketch.strokeWeight(1.5);
			sketch.line(this.p1.x,this.p1.y,this.p1.z,this.p2.x,this.p2.y,this.p2.z);
	  }
	  
	}
	

	
	function mapSpace(x,in_min, in_max,out_min,out_max) {
		return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
	}

	function linspace(startValue, stopValue, cardinality) {
		var arr = [];
		var step = (stopValue - startValue) / (cardinality - 1);
		for (var i = 0; i < cardinality; i++) {
			arr.push(startValue + (step * i));
		}
		return arr;
	}
	
	class BezierCurve{
	  constructor(points = []) {
		//TODO add the possibility to create a curve passing arguments
		
		
		this.controlPoints = [];
		this.draggedControlPointIndex = -1; // by convention = -1 if we are not dragging any point
		
		this.controlPointsX = [];
		this.controlPointsY = [];
		this.controlPointsZ = [];
		
		this.granularity = 1000;
		this.t = linspace(0,1,this.granularity);
		
		this.constructLines = [];
		this.constructPoints = [];
		this.controlPolygonLines = [];
		
		this.checkedShowControlPolygon = true;
		this.checkedShowConstructLines = true;
		this.checkedShowCurveTrace = true;
		this.checkedShowConstructPoints = true;
		
		
		if(points.length != 0){
			for(let i = 0;i<points.length; i++){
				this.addControlPoint(points[i][0],points[i][1],points[i][2])
			}
		}
	  }
	  
	  
	  addControlPoint(x,y,z){
		this.controlPoints.push(new ConstructPoint(x,y,z,true));
		this.controlPointsX.push(x);
		this.controlPointsY.push(y);
		this.controlPointsZ.push(z);
		
		
		let n = this.controlPoints.length;
		
		//number of constructPoint (interpolating points) goes as triangular sequence
		//0,1,3,6,10,15,... = n(n+1)/2
		//for n= 0 (1 control points) -> 0 interpolating points
		//for n= 1 (2 control points)-> 1 interpolating points
		//for n= 2 (3 control points) -> 3 interpolating points
		//for n = 3 (4 control points) -> 6 interpolating points
		//and so on
		for(let i = 0; i < (n*(n+1)/2 - this.constructPoints.length)-1;i++){
		  this.constructPoints.push(new ConstructPoint(x,y,z));
		}
		
		
		//number of constructLines goes as triangular sequence but with n-1 so (n-1)*(n)/2
		//for n= 0 (1 control points) -> 0 interpolating lines
		//for n= 1 (2 control points)-> 0 interpolating lines
		//for n= 2 (3 control points) -> 1 interpolating lines
		//for n = 3 (4 control points) -> 3 interpolating lines
		//for n = 4 (5 control points) -> 6 interpolating lines
		//and so on
		for(let i = 0; i< ((n-1)*n/2 - this.constructLines.length)-1; i++){
		  this.constructLines.push(new ConstructLine(this.controlPoints[this.controlPoints.length-2],this.controlPoints[this.controlPoints.length-3]));
		}
		
		

		//add Control polygon lines
		if(n>1){
		  this.controlPolygonLines.push(new ConstructLine(this.controlPoints[this.controlPoints.length-2],this.controlPoints[this.controlPoints.length-1]));
		}
		
		
		
	  }
	  
	  showConstructPoints(){
		this.checkedShowConstructPoints = !this.checkedShowConstructPoints;
	  }
	  
	  //change visibility of the control polygon
	  showControlPolygon(){
		this.checkedShowControlPolygon = !this.checkedShowControlPolygon;
	  }
	  //change visibility of construct lines (interpolating lines)
	  showConstructLines(){
		this.checkedShowConstructLines = !this.checkedShowConstructLines;
	  }
	  
	  //change visibility of curve trace
	  showCurveTrace(){
		this.checkedShowCurveTrace = ! this.checkedShowCurveTrace;
	  }
	  
	  //calculate de casteljau algorithm
	  calcBezierPoint(t){
		
		if(this.controlPoints.length == 0){ return null; }
		
		//copy control points coordinate because with them moving, can't make 
		//in place replace
		let controlPointsXCopy = [...this.controlPointsX]; 
		let controlPointsYCopy = [...this.controlPointsY];
		let controlPointsZCopy = [...this.controlPointsZ];
		let k = 0; let m = 0;
		for(let i = 0; i< this.controlPoints.length-1; i++){
		  for(let j = 0; j<this.controlPoints.length-i-1; j++){
			controlPointsXCopy[j] = (1-t)*controlPointsXCopy[j] + t*controlPointsXCopy[j+1];        
			controlPointsYCopy[j] = (1-t)*controlPointsYCopy[j] + t*controlPointsYCopy[j+1];
			controlPointsZCopy[j] = (1-t)*controlPointsZCopy[j] + t*controlPointsZCopy[j+1];
			this.constructPoints[k].x = controlPointsXCopy[j];
			this.constructPoints[k].y = controlPointsYCopy[j];
			this.constructPoints[k].z = controlPointsZCopy[j];
			
			if(j>0){
			  this.constructLines[m].p1 = this.constructPoints[k];
			  this.constructLines[m].p2 = this.constructPoints[k-1];
			  m+=1;
			}
			
			k += 1;
		  }
		}
		return [controlPointsXCopy[0], controlPointsYCopy[0],controlPointsZCopy[0]]
		
	  }
	  
	  mousePressedAction(){
		for (let i = 0; i < this.controlPoints.length; i++) {
		  let vertexUI = this.controlPoints[i];
		  
		  if(vertexUI.hasInside(sketch.mouseX,sketch.mouseY)){
			this.draggedControlPointIndex = i;
		  }
		}
		
	  }
	  
	  mouseDraggedAction(){
		if (this.draggedControlPointIndex == -1)
				return;
		let newMouseX = sketch.mouseX;
		let newMouseY = sketch.mouseY;
		
		this.controlPoints[this.draggedControlPointIndex].x = newMouseX;
		this.controlPoints[this.draggedControlPointIndex].y = newMouseY;
		this.controlPointsX[this.draggedControlPointIndex] = newMouseX;
		this.controlPointsY[this.draggedControlPointIndex] = newMouseY;
		
	  }
	   mouseReleasedAction() {
			this.draggedControlPointIndex = -1;
		}
	  
	  
	  render(){
		for(let i = 0; i < this.controlPoints.length; i++){
		  this.controlPoints[i].render();
		}
		
		
		//commented because this draws the whole curve without accounting the slider
		/*for(let i = 0; i< this.t.length; i++){
		  let tmp = this.calcBezierPoint(this.t[i]);
		  if(tmp != null){
			//console.log(tmp[0] + "  " + tmp[1]);
			stroke(0);
			strokeWeight(2);
			ellipse(tmp[0],tmp[1], 1, 1);
		  }
		}*/
		
		//the slider.value() != 0 removes imperfections in visualization. (overlapping lines or points not returning to the begininning)
		if(this.checkedShowConstructPoints && slider.value() != 0 && slider.value() != sliderMax){
		  for(let i = 0; i< this.constructPoints.length; i++){
			this.constructPoints[i].render();
		  }
		}
		
		if(this.checkedShowConstructLines && slider.value() != 0 && slider.value() != sliderMax){
		  for(let i = 0; i< this.constructLines.length; i++){
			this.constructLines[i].render();
		  }
		}
		
		if(this.checkedShowControlPolygon){
		  for(let i = 0; i< this.controlPolygonLines.length; i++){
			this.controlPolygonLines[i].render();
		  }
		}
	  
		sketch.stroke("blue");
		sketch.beginShape();
		for(let i = 0; i< mapSpace(slider.value(),0,100,0,this.granularity); i++){
			
		  let tmp = this.calcBezierPoint(this.t[i]);
		  if(tmp != null &&  this.checkedShowCurveTrace){
			sketch.strokeWeight(2);
			
			//se vuoi che la curva sia per esempio blu devi togliere quel scketch.POINTS, ma poi diventa tutto molto,molto più lento.
			sketch.vertex(tmp[0],tmp[1],tmp[2]);
		  }
		}
		sketch.stroke(0)
		sketch.endShape();
	  }
	}
	
	
	
	class ConstructPoint{
		constructor(x = null, y = null,  z = null, isControlPoint = false, radius = 3) {
			this.x = x;
			this.y = y;
			this.z = z;
			this.radius = radius;
			this.selected = false; //used for moving points around
			this.isControlPoint = isControlPoint;
		}
		render() {
			if(this.isControlPoint){
				sketch.push(); // enter local coordinate system
				sketch.translate(this.x, this.y, this.z);
				sketch.sphere(this.radius);
				sketch.pop(); // exit local coordinate system (back to global coordinates)
			}else{
				sketch.strokeWeight(5);
				sketch.beginShape(sketch.POINTS);
				sketch.vertex(this.x,this.y,this.z);
				sketch.endShape();
			}
		}  
		
		/**
		hasInside only used for a point that is a bezier control point. We need to know if the mouse is inside in order to move it.
		
		**/
		hasInside(x, y) {
			let distance = sketch.dist(this.x, this.y, x, y);
			return distance <= this.grabbableRadius; 
			
		}
	}
	
	
	sketch.mousePressed = function(){
	  bezierCurve.mousePressedAction();
	}

	sketch.mouseDragged = function(){
	  bezierCurve.mouseDraggedAction();
	}

	sketch.mouseReleased = function(){
	  bezierCurve.mouseReleasedAction()
	}
	
	sketch.windowResized = function(){ 
		let width = document.getElementById("forWidth").offsetWidth;
		sketch.resizeCanvas(width,sketch.widowHeight/1.6);
	}
	
	function myEventCheckBoxAutoPlay(){
	  checkedBoxAutoPlay = !checkedBoxAutoPlay;
	}
	
	function myEventCheckBoxShowControlPolygonLines(){
	  bezierCurve.showControlPolygon();
	}
	
	function myEventCheckBoxShowConstructLines(){
	  bezierCurve.showConstructLines();
	}

	function myEventCheckBoxShowCurveTrace(){
	  bezierCurve.showCurveTrace();
	}

	var clickNum = 0;
	function leftClick(){
		clickNum += 1;
		if(clickNum == 1){
			bezierCurve.showConstructLines();
			bezierCurve.showConstructPoints()
		}
		if(clickNum == 2){
			bezierCurve.showControlPolygon();
			clickNum = 0;
		}
	}


	function myEventCheckBoxShowConstructPoints(){
		bezierCurve.showConstructPoints();
	}
	
	function doubleClick(){
		bezierCurve.addControlPoint(0,0,0);
	}
	
	// Rotation matrix for rotation about x-axis
	function Rx(th) {
		return math.matrix([[1, 0, 0],
                 [0, sketch.cos(th), -sketch.sin(th)],
                 [0, sketch.sin(th), sketch.cos(th)]
                ]);
	}

	// Rotation matrix for rotation about y-axis
	function Ry(th) {
		return math.matrix([[sketch.cos(th), 0, -sketch.sin(th)],
                 [0, 1, 0],
                 [sketch.sin(th), 0, sketch.cos(th)]
                ])
	}
  
	// Rotation matrix for rotation about z-axis
	function Rz(th) {
		return math.matrix([[sketch.cos(th), sketch.sin(th), 0],
                [-sketch.sin(th), sketch.cos(th), 0],
                [0, 0, 1]])
	}

}
new p5(fourthSketch,"fourthCanvas");


</script>


{{< /rawhtml >}}















# Patch di Bézier 

A Bézier patch is defined as

$$ \underline{x}(u,v) = \sum_{i=0}^n \sum_{j=0}^m \underline{c}_{ij} B_i^n(u)B_j^m(v), (u,v)\in[0,1]^2$$


The skatch below shows a bicubic Bézier patch, i.e. with m=n=3.


**Warning**: If you are not correctly seeing (or not seeing) the sketch below correctly, visit [this link](https://editor.p5js.org/giggiox/full/ePuLYaR4t). Or [this link](https://editor.p5js.org/giggiox/sketches/ePuLYaR4t) to see and edit the source code.
{{< rawhtml >}}

<div id ="sixthCanvas" ></div>
<script>
var sixthSketch = function(sketch){

	var bezierSurface;


	sketch.setup = function(){
		let ctrl_pts = [
			[[0, 0, 20],  [60, 0, -35],   [90, 0, 60],    [200, 0, 5]],
			[[0, 50, 30], [100, 60, -25], [120, 50, 120], [200, 50, 5]],
			[[0, 100, 0], [60, 120, 35],  [90, 100, 60],  [200, 100, 45]],
			[[0, 150, 0], [60, 150, -35], [90, 180, 60],  [200, 150, 45]]
		];
		bezierSurface = new BezierSurface(ctrl_pts);
		sketch.frameRate(60); //change this for the slider autoplay velocity
		let width = document.getElementById("forWidth").offsetWidth;
		var myCanvas = sketch.createCanvas(width, sketch.windowHeight/1.6,sketch.WEBGL);
		
		cam1 = sketch.createCamera();
		cam1.lookAt(100,60,0);
		/* check for double click since p5js does not offer a Canvas.mouseDoubleClick but only a canvas.mouseClick. Using the function doubleClicked of p5js does not work because it's global and with more than 1 canvas on a page it gets mad */
		
		//document.getElementById("fifthCanvas").addEventListener('dblclick', doubleClick);
		
		sketch.colorMode(sketch.HSB);
		sketch.angleMode(sketch.DEGREES);
		
		
		document.getElementById("sixthCanvas").addEventListener('contextmenu',leftClick);
		document.getElementById("sixthCanvas").addEventListener('contextmenu',event => event.preventDefault()); //remove the window menu for right click
		
		
	}

	sketch.draw = function() {
		sketch.background(250);
		
		// Pan: Cam rotation about y-axis (Left Right)
		let azimuth = -sketch.atan2(cam1.eyeZ - cam1.centerZ, cam1.eyeX - cam1.centerX);
	  
		// Tilt: Cam rotation about z-axis (Up Down)
		let zenith = -sketch.atan2(cam1.eyeY - cam1.centerY, sketch.dist(cam1.eyeX, cam1.eyeZ, cam1.centerX, cam1.centerZ));
	  
		// f is a scaling factor (depends on canvas size and camera perspective settings)
		let f = sketch.height * 4.3 / 5;
		let x = [-1, (sketch.mouseY - sketch.height/2)/f, -(sketch.mouseX - sketch.width/2)/f]
	  
		let R = math.multiply(Rz(-zenith), Ry(azimuth))
		x = math.multiply(x, R)

		let xMag = sketch.dist(0, 0, 0, x._data[0], x._data[1], x._data[2])
		
		let objSelected = false;
		
		
		for(let i = 0; i < bezierSurface.controlPoints.length; i++){
			let dToObj = sketch.dist(cam1.eyeX, cam1.eyeY, cam1.eyeZ, bezierSurface.controlPoints[i].x, bezierSurface.controlPoints[i].y, bezierSurface.controlPoints[i].z);
			if(sketch.dist(cam1.eyeX + x._data[0] * dToObj / xMag, 
				cam1.eyeY + x._data[1] * dToObj / xMag, 
				cam1.eyeZ + x._data[2] * dToObj / xMag, 
				bezierSurface.controlPoints[i].x, bezierSurface.controlPoints[i].y, bezierSurface.controlPoints[i].z) < 20) {
				let canMove =  true;
				for(let j=0;j<bezierSurface.controlPoints.length;j++){
					if(i!=j && bezierSurface.controlPoints[j].selected) canMove = false;
				}
				
				if(sketch.mouseIsPressed && canMove){
					objSelected = true;
					bezierSurface.controlPoints[i].selected = true;
					
					bezierSurface.controlPoints[i].x =cam1.eyeX + (x._data[0] * dToObj) / xMag;
					bezierSurface.controlPoints[i].y =cam1.eyeY + (x._data[1] * dToObj) / xMag;
					bezierSurface.controlPoints[i].z =cam1.eyeZ + (x._data[2] * dToObj) / xMag;
				
					let idx = math.floor(i/4);
				   
					bezierSurface.bezierCurvesV[idx].controlPoints[i%4].x =bezierSurface.controlPoints[i].x;
					bezierSurface.bezierCurvesV[idx].controlPointsX[i%4] =bezierSurface.controlPoints[i].x;
					bezierSurface.bezierCurvesV[idx].controlPoints[i%4].y =bezierSurface.controlPoints[i].y;
					bezierSurface.bezierCurvesV[idx].controlPointsY[i%4] =bezierSurface.controlPoints[i].y;
					bezierSurface.bezierCurvesV[idx].controlPoints[i%4].z =bezierSurface.controlPoints[i].z;
					bezierSurface.bezierCurvesV[idx].controlPointsZ[i%4] =bezierSurface.controlPoints[i].z;
				}else{
					bezierSurface.controlPoints[i].selected = false;
					objSelected = false;
				}
			}
		}
		
		
		
		
		if (!objSelected) {
			sketch.orbitControl(1,1);
		}
		bezierSurface.render();
	}
	
	
	

	function linspace(startValue, stopValue, cardinality) {
		var arr = [];
		var step = (stopValue - startValue) / (cardinality - 1);
		for (var i = 0; i < cardinality; i++) {
			arr.push(startValue + (step * i));
		}
		return arr;
	}
	
	class ConstructPoint{
		constructor(x = null, y = null, z = null, isControlPoint = false) {
			this.x = x
			this.y = y
			this.z = z;
			this.selected = false; //used for moving point around
			this.isControlPoint = isControlPoint;
		}
		render() {
			if(this.isControlPoint){
				sketch.push();
				sketch.translate(this.x,this.y,this.z);
				sketch.sphere(2)
				sketch.pop();
			}else{
				sketch.strokeWeight(5);
				sketch.beginShape(POINTS);
				sketch.vertex(this.x,this.y,this.z);
				sketch.endShape();
			}
        }
	}
	
	class BezierSurface{
		constructor(points = []){
			this.showNet = true;
			this.showingNetPoints = true;
			this.controlPoints = [];
			this.u = 10;
			this.v = 10;
			this.bezierCurvesV = [];
			this.bezierCurvesU = [];
			
			if(points.length != 0){
				for(let i = 0;i<points.length; i++){
					for(let j = 0;j<points[0].length;j++){
						this.addControlPoint(points[i][j][0],points[i][j][1],points[i][j][2],true);
					}
				}
				for(let i=0;i<points.length;i++){
					let bz = new BezierCurve(points[i]);
					bz.showCurve = false;
					bz.changeGranularity(this.v);
					this.bezierCurvesV.push(bz);
				}
				for(let j=0;j<this.v;j++){
					let bz = new BezierCurve();
					bz.changeGranularity(this.u);
					this.bezierCurvesU.push(bz);
				}
			}
		}
		showNetPoints(){
			this.showingNetPoints = !this.showingNetPoints;
		}
		
		showNetEvent(){
			this.showNet = !this.showNet;
		}
  
		addControlPoint(x,y,z,isControlPoint = false){
			this.controlPoints.push(new ConstructPoint(x,y,z,isControlPoint));
		}
 
		render(){
			for(let i = 0; i < this.controlPoints.length; i++){
				if(this.showingNetPoints){
					this.controlPoints[i].render();
				}
				sketch.strokeWeight(1)
				let coloumnsNumber = this.bezierCurvesV.length;
				if(i%coloumnsNumber != 0 && this.showNet){ 
					sketch.line(this.controlPoints[i].x,this.controlPoints[i].y,this.controlPoints[i].z,this.controlPoints[i-1].x,this.controlPoints[i-1].y,this.controlPoints[i-1].z)
				}
				if(i>=coloumnsNumber && this.showNet){
					sketch.line(this.controlPoints[i].x,this.controlPoints[i].y,this.controlPoints[i].z,this.controlPoints[i-coloumnsNumber].x,this.controlPoints[i-coloumnsNumber].y,this.controlPoints[i-coloumnsNumber].z)
				}
			}
			for(let i=0;i<this.bezierCurvesV.length;i++){
				this.bezierCurvesV[i].render();
			}
    
    
			for(let j=0;j<this.v;j++){
				let cpoints = [];
				for (let k = 0; k < this.bezierCurvesV[0].controlPoints.length; k++) {
					cpoints.push([this.bezierCurvesV[k].points[j][0],this.bezierCurvesV[k].points[j][1],this.bezierCurvesV[k].points[j][2]]);
				}
				this.bezierCurvesU[j] = new BezierCurve(cpoints)
				this.bezierCurvesU[j].changeGranularity(this.u);
				this.bezierCurvesU[j].showCurve = false;
				this.bezierCurvesU[j].render();
			}
			
			for(let j=0;j<this.v-1;j++){
				for(let i=0;i<this.bezierCurvesU[j].points.length-1;i++){
					sketch.beginShape(sketch.QUAD_STRIP);
					sketch.vertex(this.bezierCurvesU[j].points[i][0],this.bezierCurvesU[j].points[i][1],this.bezierCurvesU[j].points[i][2]);
					sketch.vertex(this.bezierCurvesU[j+1].points[i][0],this.bezierCurvesU[j+1].points[i][1],this.bezierCurvesU[j+1].points[i][2]);
					sketch.vertex(this.bezierCurvesU[j].points[i+1][0],this.bezierCurvesU[j].points[i+1][1],this.bezierCurvesU[j].points[i+1][2]);
					sketch.vertex(this.bezierCurvesU[j+1].points[i+1][0],this.bezierCurvesU[j+1].points[i+1][1],this.bezierCurvesU[j+1].points[i+1][2])
					sketch.endShape();
				}				
			}
		}
  
	}
	
	class BezierCurve{
		constructor(points = []) {
			this.showCurve = true;
			this.rendered = false;
			this.controlPoints = [];
			this.draggedControlPointIndex = -1; // by convention = -1 if we are not dragging any point
			
			this.controlPointsX = [];
			this.controlPointsY = [];
			this.controlPointsZ = [];
			
			this.granularity = 1000;
			this.t = linspace(0,1,this.granularity);
			
			this.points = Array(this.granularity).fill(0);
			
			this.constructLines = [];
			this.constructPoints = [];
			this.controlPolygonLines = [];
			
			this.checkedShowControlPolygon = true;
			this.checkedShowConstructLines = true;
			this.checkedShowCurveTrace = true;
			
			if(points.length != 0){
			  for(let i = 0;i<points.length; i++){
				this.addControlPoint(points[i][0],points[i][1],points[i][2]);
			  }
			}
		}
   
  
		changeGranularity(x){
			this.granularity = x;
			this.t = linspace(0,1,x);
			this.points = Array(x).fill(0);
		}
  
		addControlPoint(x,y,z){
			this.controlPoints.push(new ConstructPoint(x,y,z));
			this.controlPointsX.push(x);
			this.controlPointsY.push(y);
			this.controlPointsZ.push(z);
		}
  
		//calculate de casteljau algorithm
		calcBezierPoint(t){
    
			if(this.controlPoints.length == 0){ return null; }
    
			//copy control points coordinate because with them moving, can't make 
			//in place replace
			let controlPointsXCopy = [...this.controlPointsX]; 
			let controlPointsYCopy = [...this.controlPointsY];
			let controlPointsZCopy = [...this.controlPointsZ];
			let k = 0; let m = 0;
			for(let i = 0; i< this.controlPoints.length-1; i++){
				for(let j = 0; j<this.controlPoints.length-i-1; j++){
					controlPointsXCopy[j] = (1-t)*controlPointsXCopy[j] + t*controlPointsXCopy[j+1];      
					controlPointsYCopy[j] = (1-t)*controlPointsYCopy[j] + t*controlPointsYCopy[j+1];
					controlPointsZCopy[j] = (1-t)*controlPointsZCopy[j] + t*controlPointsZCopy[j+1];
				}
			}
			return [controlPointsXCopy[0], controlPointsYCopy[0], controlPointsZCopy[0]]
    
		}
  
  
		render(){	
			if (this.showCurve) {
				sketch.beginShape(sketch.POINTS);
				sketch.strokeWeight(2);
				sketch.stroke("blue");
				for (let i = 0; i < this.t.length; i++) {
					let tmp = this.calcBezierPoint(this.t[i]);
					if (tmp != null) {
						sketch.vertex(tmp[0], tmp[1], tmp[2]);
						this.points[i] = [tmp[0], tmp[1], tmp[2]];
					}
				}
				sketch.stroke(0)
				sketch.endShape();
			}else{
				for (let i = 0; i < this.t.length; i++) {
					let tmp = this.calcBezierPoint(this.t[i]);
					if (tmp != null) {
						this.points[i] = [tmp[0], tmp[1], tmp[2]];
					}
				}
			}
		}
	}
	sketch.windowResized = function(){ 
		let width = document.getElementById("forWidth").offsetWidth;
		sketch.resizeCanvas(width,sketch.widowHeight/1.6);
	}
	
	let clickNum = 0;
	function leftClick(){
		clickNum += 1;
		if(clickNum == 1){
			bezierSurface.showNetEvent();
		}
		if(clickNum == 2){
			bezierSurface.showNetPoints();
			clickNum = 0;
		}
		
	}
	
	
	// Rotation matrix for rotation about x-axis
	function Rx(th) {
		return math.matrix([[1, 0, 0],
                 [0, sketch.cos(th), -sketch.sin(th)],
                 [0, sketch.sin(th), sketch.cos(th)]]);
	}

	// Rotation matrix for rotation about y-axis
	function Ry(th) {
		return math.matrix([[sketch.cos(th), 0, -sketch.sin(th)],
                 [0, 1, 0],
                 [sketch.sin(th), 0, sketch.cos(th)]]);
	}
  
	// Rotation matrix for rotation about z-axis
	function Rz(th) {
		return math.matrix([[sketch.cos(th), sketch.sin(th), 0],
                [-sketch.sin(th), sketch.cos(th), 0],
                [0, 0, 1]]);
	}
	
	

}






new p5(sixthSketch,"sixthCanvas");




</script>
{{< /rawhtml >}} 














{{< rawhtml >}} 


<style>

  .checkbox-wrapper-6 .tgl {
    display: none;
  }
  .checkbox-wrapper-6 .tgl,
  .checkbox-wrapper-6 .tgl:after,
  .checkbox-wrapper-6 .tgl:before,
  .checkbox-wrapper-6 .tgl *,
  .checkbox-wrapper-6 .tgl *:after,
  .checkbox-wrapper-6 .tgl *:before,
  .checkbox-wrapper-6 .tgl + .tgl-btn {
    box-sizing: border-box;
  }
  .checkbox-wrapper-6 .tgl::-moz-selection,
  .checkbox-wrapper-6 .tgl:after::-moz-selection,
  .checkbox-wrapper-6 .tgl:before::-moz-selection,
  .checkbox-wrapper-6 .tgl *::-moz-selection,
  .checkbox-wrapper-6 .tgl *:after::-moz-selection,
  .checkbox-wrapper-6 .tgl *:before::-moz-selection,
  .checkbox-wrapper-6 .tgl + .tgl-btn::-moz-selection,
  .checkbox-wrapper-6 .tgl::selection,
  .checkbox-wrapper-6 .tgl:after::selection,
  .checkbox-wrapper-6 .tgl:before::selection,
  .checkbox-wrapper-6 .tgl *::selection,
  .checkbox-wrapper-6 .tgl *:after::selection,
  .checkbox-wrapper-6 .tgl *:before::selection,
  .checkbox-wrapper-6 .tgl + .tgl-btn::selection {
    background: none;
  }
  .checkbox-wrapper-6 .tgl + .tgl-btn {
    outline: 0;
    display: block;
    width: 4em;
    height: 2em;
    position: relative;
    cursor: pointer;
    -webkit-user-select: none;
       -moz-user-select: none;
        -ms-user-select: none;
            user-select: none;
  }
  .checkbox-wrapper-6 .tgl + .tgl-btn:after,
  .checkbox-wrapper-6 .tgl + .tgl-btn:before {
    position: relative;
    display: block;
    content: "";
    width: 50%;
    height: 100%;
  }
  .checkbox-wrapper-6 .tgl + .tgl-btn:after {
    left: 0;
  }
  .checkbox-wrapper-6 .tgl + .tgl-btn:before {
    display: none;
  }
  .checkbox-wrapper-6 .tgl:checked + .tgl-btn:after {
    left: 50%;
  }

  .checkbox-wrapper-6 .tgl-light + .tgl-btn {
    background: #f0f0f0;
    border-radius: 2em;
    padding: 2px;
    transition: all 0.4s ease;
  }
  .checkbox-wrapper-6 .tgl-light + .tgl-btn:after {
    border-radius: 50%;
    background: #fff;
    transition: all 0.2s ease;
  }
  .checkbox-wrapper-6 .tgl-light:checked + .tgl-btn {
    background: #0000fe;
  }
  

canvas {

  border-radius: 30px;
}


.myslider {
  -webkit-appearance: none;
  width: 100%;
  height: 15px;
  border-radius: 5px;  
  background: #d3d3d3;
  outline: none;
  opacity: 0.7;
  -webkit-transition: .2s;
  transition: opacity .2s;
}

.myslider::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 25px;
  height: 25px;
  border-radius: 50%; 
  background: #0000fe;
  cursor: pointer;
}

.myslider::-moz-range-thumb {
  width: 25px;
  height: 25px;
  border-radius: 50%;
  background: #0000fe;
  cursor: pointer;
}

.button {
  background-color: #0000fe;
  border: none;
  color: white;
  padding: 20px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 4px 2px;
  cursor: pointer;
}
.button2 {border-radius: 8px;}

</style>

{{< /rawhtml >}}



# p5js Implementation Notes

The code is written with the [p5js](https://p5js.org/es/) library and was written using OOP methodology.
In general, all 2d-3d versions and also Bézier patches consist of the following classes and methods:

```js
class BezierCurve{
	function constructor(points: Array[Array[float]]){}
	function addControlPoint(x: float, y: float){}
	function deCastelJau(t: float){}
	function render(){
		//ConstructPoints.render() for all ConstructPoints
		//ConstructLines.render() for all ConstructLines
	}
}

class ConstructPoint{
	function constructor(x: float, y: float) {}
	function render() {}  
	function hasInside(x: float, y: float) {}
}

class ConstructLine{  
	function constructor(p1: ConstructPoint,p2: ConstructPoint) {}
	function render(){}
}

```

So to create a Bézier curve you need to instantiate a `var bezierCurve = BezierCurve(points)`, then on the p5js `draw()` method call the curve's render method like this: `bezierCurve.render()`.


For the Bézier patches, however, an additional class has been created which instantiates multiple BezierCurve classes.

```js
class BezierPatch{
	function constructor(points: Array[Array[float]]){}
	function addControlPoint(x: float, y: float){}
	function render(){}
}

```