
giBEncode = 1 ;Render B-format alongside stereo render? (1 = yes, 0 = no)

instr g1
;irand = random(1,8)
;iranddur=random(0.2,9)
irandpitch=random(-2, 4)
Sample = sound("gran", 2)
Smachine = "grain"
ichance = 0.999
idur=p3
print idur
kpitch[] fillarray 0.2,0.57, idur ;maps to trilfo // lo, hi rate.
kstr[] fillarray 0.2, 1, idur ;maps to trilfo // lo, hi rate.
kgrd[] fillarray 30, 10, idur ;2 to 32
kgrs[] fillarray 0.4, 0.1, idur 	;0.1 to 1 
seq(ichance, Smachine, Sample,idur,kpitch,kstr,kgrd,kgrs)
;schedule(p1,idur,1)
prints "Sample: %i %s \n", p1, Sample
;render("grain")
kdelay=0.2
kfb=0.3
kdpitch=2;linseg(1,idur, 0.5)
kmix=0.5
adelL, adelR pdelay "grain",kdelay,kfb,kdpitch,kmix
kalpha line 0, p3, 720
kbeta randh 100, 2
mixencoded(adelL, adelR, kalpha, kbeta)
;reverb_mix(adelL,adelR,0.9)
endin

schedule("g1", 0, 20) 


