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

select = 1
modosc = 200
loop = 9
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
if (tidal.select === 0){
 select = 0
}
else if (tidal.select === 1){
 select = 1
}
else if (tidal.select === 2){
 select = 2
}
else if (tidal.select === 3){
 select = 3
}
})

//Load images to canvases

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
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'/media/img4.jpg')
  p3.draw = () => {
    p3.clear()
    p3.image(vid3, 0, 2, p3.width, p3.height)
  }
p3.hide()


// use video within hydra

redval = Math.sin(time)*.2
bluval = Math.sin(time)*.4
s0.init({src: p0.canvas})
s1.init({src: p1.canvas})
s2.init({src: p2.canvas})
s3.init({src: p3.canvas})
if (select===1) {
    source = s1
}else{
  source = s0
}
//srcSelect=(()=>select)
  src(s0)
    .modulatePixelate(noise(25,0.5),1000)
    .modulateRotate(osc(0.2),1,0.01) //multiple, scrollX, speed
    .modulateScale(osc(10,1,0),2)
    .out(o1)
  src(s1)
      //.blend(s2,3,2,1)
      //.repeatX(Math.sin(time)*3, 1)
      //.modulateRotate(osc(0.7))
      //.saturate(10)
    //  .modulateScale(osc(0.1,3,0),10)
      //.thresh(({time})=>Math.sin(time)*0.2,10)
    //  .color(0.9,0.7, bluval*0.3,0,1,0)
    //  .modulate(osc([10, 0.2, 1]), 0.2)
    //  .modulatePixelate(osc(1,2,1000),1000)
      .out(o2)
    //s2.init({src: p3.canvas})
    src(s2)
          .repeatX(Math.sin(time)*3, 1)
          //.modulateRotate(osc(0.7))
          .saturate(0.1)
          .modulateScale(osc(0.1,0.2,0),10)
          .thresh(({time})=>Math.sin(time)*0.2,10)
          .color(0.9,0.7, bluval*0.3,0,1,0)
          //.modulate(osc([10, 0.2, 1]), 0.2)
          .modulatePixelate(osc(20,0.1,1),100)
          .out( o2)
//shape([30, 7, 9].fast(9.0)).modulateScale(osc(10)).out(o3)
    src(s3)
        //.blend(s1, 2)
        //.blend(s1, 9)
        .blend(source, 1)
        .add(s2)
        .modulatePixelate(osc(0.2,0.1,10),2000)
        .modulateScale(osc(0.1,0.5,0),1)
        //.brightness(()=>bright)
        //.add(osc(0.3,1,8))
        .mask(shape([20, 20, 4].fast(0.7)).modulateScale(osc(()=>modosc)).repeatX(()=>loop*Math.sin(4)))
      .out(o3)

render(o3)
