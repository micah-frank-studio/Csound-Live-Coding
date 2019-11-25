
start("ReverbMixer")
giBEncode = 1 ;Render B-format alongside stereo render? (1 = yes, 0 = no)
; samples 109, 52

instr g1 
irand = random(1,118) ;iranddur=random(0.2,9)
irandpitch=random(-2, 4)
Sample = sound("field", 3)
Smachine = "grain"
idur =p3 
kamp = 0.2
ichance = 0.999
kpitch[] fillarray 0.5,0.57, idur ;maps to trilfo // lo, hi rate.
kstr[] fillarray 0.05, 0.2, idur ;2 to 0.01
kgrd[] fillarray 10, 20, idur ;2 to 32
kgrs[] fillarray 0.1, 0.1, idur 	;0.1 to 1 
seq(kamp, ichance, Smachine, Sample,idur,kpitch,kstr,kgrd,kgrs)
prints "Sample: %i %s Number: %i \n", p1, Sample,irand
;render("grain")
kdelay=0.4
kfb=0.4
kdpitch=linseg(1,idur, 0.5)
kdelmix=0.4
adelL, adelR pdelay "grain",kdelay,kfb,kdpitch,kdelmix
kalpha line 0, p3, 720
kbeta randh 100, 2
;mixencoded(adelL, adelR, kalpha, kbeta)
reverb_mix(adelL,adelR,0.3)
;schedule(p1,p3,p3)
endin

schedule("g1", 0, 15)

