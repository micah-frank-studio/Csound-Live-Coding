
instr g1
;irand = random(1,8)
;iranddur=random(0.2,9)
irandpitch=random(-2, 4)
Sample = sound("gran", 16)
Smachine = "grain"
ichance = 0.999
idur=p3
kpitch[] fillarray 1.2,0.7, idur ;maps to trilfo // lo, hi rate.
kstr[] fillarray 0.2, 1, idur ;maps to trilfo // lo, hi rate.
kgrd[] fillarray 3, 10, idur ;2 to 32
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
reverb_mix(adelL,adelR,0.9)
endin

schedule("g1", 0, 20) 

endin


