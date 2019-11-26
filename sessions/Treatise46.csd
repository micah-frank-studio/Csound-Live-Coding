
giBEncode = 1 ;Render B-format alongside stereo render? (1 = yes, 0 = no)

schedule("forest", 0, 60)
schedule("lorax", 0, 60)
schedule("spindle", 0, 10)
schedule("earth", 0, 5)

instr forest 
irand = random(1,118) ;iranddur=random(0.2,9)
irandpitch=random(-2, 4)
Sample = sound("field", 3)
Smachine = "grain"
idur =p3 
isusamp=0.2 ; max sustain volume
kamp =linseg(0,1,0.2,p3-(p3*0.1-1),isusamp,p3*0.1-1,0) 
;ichance = 0.999
kpitch=linseg(0.2,p3*0.5,0.7,p3*0.5,0.2)
kstr=linseg(0.1, p3*0.5, 2, p3*0.5, 1)
kdens=20
kgrsize=0.6
;seq(kamp, ichance, Smachine, Sample,idur,kpitch,kstr,kgrd,kgrs)
			iL ftgen 0, 0, 0, 1, Sample, 0, 0, 1
			iR ftgen 0, 0, 0, 1, Sample, 0, 0, 2
prints "Sample: %i %s Number: %i \n", p1, Sample,irand
iolaps = 2
ips     = 1/iolaps
	a1L syncloop kamp, kdens, kpitch, kgrsize, ips*kstr, 0, ftlen(iL)/sr, iL, 1, iolaps
	a1R syncloop kamp, kdens, kpitch, kgrsize, ips*kstr, 0, ftlen(iR)/sr, iR, 1, iolaps
;busmix("grain", a1L, a1R)
kdelay=0.4
kfb=0.4
kdpitch=linseg(1,idur, 0.5)
kdelmix=0.4
adelL, adelR pdelay a1L,a1R,kdelay,kfb,kdpitch,kdelmix
kalpha line 0, p3, 720
kbeta randh 100, 2
;mixencoded(adelL, adelR, kalpha, kbeta)
al, ar declickst adelL, adelR
reverb_mix(al,ar,0.4)
;schedule(p1,p3,p3)
endin


instr lorax
irand = random(1,118) ;iranddur=random(0.2,9)
irandpitch=random(-2, 4)
Sample = sound("spire", 4)
Smachine = "grain"
idur =p3 
kamp = 0.2
kpitch=linseg(0.2,p3,0.3)
kstr=linseg(2.1, p3*0.5, 1, p3*0.5, 1)
kdens=10
kgrsize=0.2
			iL ftgen 0, 0, 0, 1, Sample, 0, 0, 1
			iR ftgen 0, 0, 0, 1, Sample, 0, 0, 2
prints "Sample: %i %s Number: %i \n", p1, Sample,irand
iolaps = 2
ips     = 1/iolaps
	a1L syncloop kamp, kdens, kpitch, kgrsize, ips*kstr, 0, ftlen(iL)/sr, iL, 1, iolaps
	a1R syncloop kamp, kdens, kpitch, kgrsize, ips*kstr, 0, ftlen(iR)/sr, iR, 1, iolaps
;busmix("grain2", a1L, a1R)
kdelay=0.4
kfb=0.4
kdpitch=linseg(1,idur, 0.5)
kdelmix=0.4
adelL, adelR pdelay a1L,a1R,kdelay,kfb,kdpitch,kdelmix
kalpha line 0, p3, 720
kbeta randh 100, 2
;mixencoded(adelL, adelR, kalpha, kbeta)
al, ar declickst adelL, adelR
reverb_mix(al,ar,0.4)
;schedule(p1,p3,p3)
endin

instr spindle
	Sample = sound("soundbits", 11)
kamp = 0.2
kfreq=30
kpitch = linseg(2.2, p3*0.33, 2.2, p3*0.56, 0.1)
kgrsize=0.1
kprate=4.2;random(-1, 3)
ifun = gi1
iolaps = 10
agrainL, agrainR diskgrain Sample, kamp, kfreq, kpitch, kgrsize, kprate, ifun, iolaps
al, ar declickst agrainL, agrainR
kverbmix=linseg(0.01, p3*0.5, 0.99, p3*0.5, 0.01)
reverb_mix(al,ar,0.7)
;schedule(p1, p3, p3)
endin

instr earth
	iampsus =random(0.1,0.5) 
	kamp=0.2;expseg(iampsus, p3, 0.001)
	irand=random(0.01, 50)
	irand2=random(0.01,50)
	kmod = linseg(irand, p3, irand2) ;create random modulator for VCO freq
	amodfreq =vco2(kamp, kmod,12) 
	kfreq=random(90, 220)
;	kfreq = 90
	avco vco2 kamp, kfreq, 12
	asig=avco*amodfreq
	al declick asig
	reverb_mix(al, al, 0.8)
;	schedule(p1,p3,p3)
endin
