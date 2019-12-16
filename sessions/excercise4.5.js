// set port to listen to osc messages. default port is 57101
msg.setPort(3333)
parseTidal = (args) => {
  obj = {}
  for(var i = 0; i < args.length; i+=2){
    obj[args[i]] = args[i+1]
  }
  return obj
}

// receive messages from supercollider in hydra. '/play2' corresponds to the
// address of the OSC message, defined in the file tidal-forward.sc
// open the console to see the messages, using Ctrl+Alt+I (windows), Cmd+Opt+I (mac), or Ctrl + Shift + I(linux)
//


//Load images to canvases

loop=300
modosc=2
blend1=0.1
blend2=0.1
var vid3
  p0 = new P5()
    // load video
    vid0 = p0.loadImage(atom.project.getPaths()[0]+'/media/img9.jpg')
    p0.draw = () => {
      p0.clear()
      p0.image(vid0, 0, 2, p0.width, p0.height)
    }
  p0.hide()
p1 = new P5()
  // load video
  vid1 = p1.loadImage(atom.project.getPaths()[0]+'/media/img8.jpg')
  p1.draw = () => {
    p1.clear()
    p1.image(vid1, 0, 2, p1.width, p1.height)
  }
p1.hide()
p2 = new P5()
  // load video
  vid2 = p2.loadImage(atom.project.getPaths()[0]+'/media/img10.jpg')
  p2.draw = () => {
    p2.clear()
    p2.image(vid2, 0, 2, p2.width, p2.height)
  }
p2.hide()
p3 = new P5()
  // load video
  vid3 //= p3.loadImage(atom.project.getPaths()[0]+'/media/img4.jpg')
  p3.draw = () => {
    p3.clear()
    p3.image(vid3, 0, 2, p3.width, p3.height)
  }
p3.hide()
vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img4.jpg')
msg.on('/play2', (args) => {
// log osc results to console
 log(args)
 tidal = parseTidal(args)
 if (tidal.loop > 0) {
   loop = tidal.loop
}
if (tidal.modosc > 0) {
    modosc = tidal.modosc
  }
if (tidal.blend1 > 0) {
      blend1 = tidal.blend1
    }
if (tidal.blend2 > 0) {
      blend2 = tidal.blend2
      }
if (tidal.image === 0){
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img0.jpg')
  vid2 = p3.loadImage(atom.project.getPaths()[0]+'/media/img6.jpg')
  vid1 = p3.loadImage(atom.project.getPaths()[0]+'/media/img9.jpg')
}
else if (tidal.image === 1){
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img1.jpg')
  vid2 = p3.loadImage(atom.project.getPaths()[0]+'/media/img2.jpg')
  vid1 = p3.loadImage(atom.project.getPaths()[0]+'/media/img8.jpg')
}
else if (tidal.image === 2){
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img2.jpg')
  vid2 = p3.loadImage(atom.project.getPaths()[0]+'/media/img0.jpg')
  vid1 = p3.loadImage(atom.project.getPaths()[0]+'/media/img6.jpg')
}
else if (tidal.image === 3){
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img3.jpg')
  vid2 = p3.loadImage(atom.project.getPaths()[0]+'/media/img1.jpg')
  vid1 = p3.loadImage(atom.project.getPaths()[0]+'/media/img2.jpg')
}
else if (tidal.image === 4){
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img4.jpg')
  vid2 = p3.loadImage(atom.project.getPaths()[0]+'/media/img10.jpg')
  vid1 = p3.loadImage(atom.project.getPaths()[0]+'/media/img8.jpg')
}
else if (tidal.image === 5){
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img5.jpg')
  vid2 = p3.loadImage(atom.project.getPaths()[0]+'/media/img11.jpg')
  vid1 = p3.loadImage(atom.project.getPaths()[0]+'/media/img2.jpg')
}
else if (tidal.image === 6){
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img6.jpg')
  vid1 = p3.loadImage(atom.project.getPaths()[0]+'/media/img11.jpg')
  vid2 = p3.loadImage(atom.project.getPaths()[0]+'/media/img8.jpg')
}
else if (tidal.image === 7){
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img7.jpg')
  vid1 = p3.loadImage(atom.project.getPaths()[0]+'/media/img1.jpg')
  vid2 = p3.loadImage(atom.project.getPaths()[0]+'/media/img4.jpg')
}
else if (tidal.image === 8){
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img8.jpg')
  vid1 = p3.loadImage(atom.project.getPaths()[0]+'/media/img5.jpg')
  vid2 = p3.loadImage(atom.project.getPaths()[0]+'/media/img10.jpg')
}
else if (tidal.image === 9){
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img9.jpg')
  vid2 = p3.loadImage(atom.project.getPaths()[0]+'/media/img3.jpg')
  vid1 = p3.loadImage(atom.project.getPaths()[0]+'/media/img0.jpg')
}
else if (tidal.image === 10){
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img10.jpg')
  vid1 = p3.loadImage(atom.project.getPaths()[0]+'/media/img1.jpg')
  vid2 = p3.loadImage(atom.project.getPaths()[0]+'/media/img0.jpg')
}
else if (tidal.image === 11){
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img11.jpg')
  vid2 = p3.loadImage(atom.project.getPaths()[0]+'/media/img5.jpg')
  vid1 = p3.loadImage(atom.project.getPaths()[0]+'/media/img6.jpg')
}
})


// use video within hydra

redval = Math.sin(time)*.2
bluval = Math.sin(time)*.4
s0.init({src: p0.canvas})
s1.init({src: p1.canvas})
s2.init({src: p2.canvas})
s3.init({src: p3.canvas})
//srcSelect=(()=>select)
  src(s0)
    .modulatePixelate(noise(25,0.5),1000)
    .modulateRotate(osc(0.2),1,0.01) //multiple, scrollX, speed
    .modulateScale(osc(10,1,0),2)
    .out(o1)
    src(s2)
          .repeatX(Math.sin(time)*3, 1)
          //.modulateRotate(osc(0.7))
          .saturate(0.1)
          .modulateScale(osc(0.1,0.2,0),10)
          .thresh(({time})=>Math.sin(time)*0.2,10)
          .color(0.9,0.7, bluval*0.3,0,1,0)
          //.modulate(osc([10, 0.2, 1]), 0.2)
          .modulatePixelate(osc(20,0.1,1),100)
          .out(o3)
//shape([30, 7, 9].fast(9.0)).modulateScale(osc(10)).out(o3)
    src(s3)
        .blend(o1, ()=>blend1)
        .blend(o3, ()=>blend2)
        .blend(s2, ()=>blend1)
        //.add(o1)
        .modulatePixelate(osc(0.2,0.1,1),700)
        .modulateScale(osc(0.01,3,0),1)
        //.modulateRepeatX(osc(0.1))
        //.brightness(()=>bright)
        .mask(shape([30,90].fast(0.2)).modulateScale(osc(()=>modosc)).repeatX(()=>loop*Math.sin(4)))
      .out(o3)

render(o3)
