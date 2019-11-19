;start("ReverbMixer")

instr g1
;irand = random(1,8)
;iranddur=random(0.2,9)
irandpitch=random(-2, 4)
Sample = sound("tone", 11)
Smachine = "grain"
ichance = 0.999
idur=20
kpitch[] fillarray 0.2,0.2, idur ;maps to trilfo // lo, hi rate.
kstr[] fillarray 0.2, 1, idur ;maps to trilfo // lo, hi rate.
kgrd[] fillarray 3, 10, idur ;2 to 32
kgrs[] fillarray 0.4, 0.1, idur 	;0.1 to 1 
seq(ichance, Smachine, Sample,idur,kpitch,kstr,kgrd,kgrs)
;schedule(p1,idur,1)
prints "%i %s \n", p1, Sample
endin


instr g2
;irand = random(1,8)
;iranddur=random(0.2,9)
;irandpitch=random(-2, 4)
Sample = sound("gran", 16)
Smachine = "grain"
ichance = 0.999
idur=20
kpitch[] fillarray 0.15, 0.15, idur ;maps to trilfo // lo, hi rate.
kstr[] fillarray 0.2, 2, idur ;maps to trilfo // lo, hi rate.
kgrd[] fillarray 22, 2, idur ;2 to 32
kgrs[] fillarray 0.4, 0.3, idur 	;0.1 to 1 
seq(ichance, Smachine, Sample,idur,kpitch,kstr,kgrd,kgrs)
;schedule(p1,idur,1)
prints "%i %s \n", p1, Sample
endin

schedule("g1", 0, 1)
schedule("g2",0,1)

turnoff2("g2",0, 0)

mute("g1")
