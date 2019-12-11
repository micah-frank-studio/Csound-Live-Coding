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
msg.on('/play2', (args) => {
// log osc results to console
 //log(args)
 tidal = parseTidal(args)
 console.log(tidal)
})

// receive args from supercollider in hydra. Tidal sends OSC messages
// ahead of the time the sound is plays, so it is necessary to use setTimeout
// in order to wait to change the visuals
msg.on('/play2', (args) => {
  // parse the values from tidal
 var tidal = parseTidal(args)
//
bright = 0.1
source = o1
squ = 0.5
  setTimeout(() => {  //
  // If the tidal sample is "sd", set blend to 0, if it is bd, set blend to 1
  //
   if(tidal.forest === "forest"){
       squ = tidal.forest
   } else if (tidal.spindle === "spindle"){
       squ = tidal.spindle
   } else if (tidal.earth === "earth"){
       squ = 30
     }
     //
  }, tidal.delta * 1000)
  })

p1 = new P5()
  // load video
  vid1 = p1.loadImage(atom.project.getPaths()[0]+'../media/IMG_5981.jpg')
  // set video to loop
  //vid1.loop()
  // draw to canvas
  p1.draw = () => {
    p1.clear()
    p1.image(vid1, 0, 2, p1.width, p1.height)
  }
p1.hide()

p2 = new P5()
  // load video
  vid2 = p2.loadImage(atom.project.getPaths()[0]+'../media/IMG_0145.jpg')
  // set video to loop
  //vid1.loop()
  // draw to canvas
  p2.draw = () => {
    p2.clear()
    p2.image(vid2, 0, 2, p2.width, p2.height)
  }
p2.hide()

p3 = new P5()
  // load video
  vid3 = p3.loadImage(atom.project.getPaths()[0]+'../media/IMG_5113.jpg')
  // set video to loop
  //vid1.loop()
  // draw to canvas
  p3.draw = () => {
    p3.clear()
    p3.image(vid3, 0, 2, p3.width, p3.height)
  }
p3.hide()

// use video within hydra
redval = Math.sin(time)*.2
bluval = Math.sin(time)*.4
s0.init({src: p1.canvas})
  src(s0)
    .modulatePixelate(osc(0.1,8,10),1000)
    //.modulateRotate(osc(0.2),1,0.01) //multiple, scrollX, speed
    //.modulateScale(osc(0.3,-0.5,0),2)
    //.color(redval,0.3, Math.sin(time)*2,3,0,0)
    //.modulatePixelate(osc([0.1, 2, 0.1]), 0.5)
    .out(o1)

  s1.init({src: p2.canvas})
  src(s1)
      .repeatX(Math.sin(time)*3, 1)
      //.modulateRotate(osc(0.7))
      //.saturate(10)
      .modulateScale(osc(0.1,3,0),10)
      //.thresh(({time})=>Math.sin(time)*0.2,10)
      .color(0.9,0.7, bluval*0.3,0,1,0)
      .modulate(osc([10, 0.2, 1]), 0.2)
      .modulatePixelate(osc(1,2,1000),1000)
      .out(o0)

s2.init({src: p3.canvas})
      src(s2)
          .repeatX(Math.sin(time)*3, 1)
          //.modulateRotate(osc(0.7))
          .saturate(0.5)
          .modulateScale(osc(0.1,0.2,0),10)
          //.thresh(({time})=>Math.sin(time)*0.2,10)
          //.color(0.9,0.7, bluval*0.3,0,1,0)
          .modulate(osc([10, 0.2, 1]), 0.2)
          .modulatePixelate(osc(0.2,0.1,1),10)
          .out(o3)

//shape([30, 7, 9].fast(9.0)).modulateScale(osc(10)).out(o3)

src(o0)
  .blend(o1, 3, ()=>bright, 4)
  .add(o3)
  //.modulatePixelate(osc(0.2,0.3,100),700)
  .modulateScale(osc(0.1,3,0),1)
  //.brightness(()=>bright)
  .add(osc(0.3,1,8))
  .mask(shape([200, 20, 4].fast(0.3)).modulateScale(osc(()=>squ)).repeatX(300*Math.sin(5)))
.out(o2)


render(o2)
