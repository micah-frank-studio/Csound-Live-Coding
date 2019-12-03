
*** LARUM ENSEMBLE ***

VARIATIONS ON CORNELIUS CARDEW'S "TREATISE"
PREPARED PIANO : JACOB SACKS
SAXOPHONE : CHET DOXAS
LIVE CODE : MICAH FRANK

monitorMode 0 	;0 = stereo, 1 = ambisonic
schedule("thepast", 0, 300, 19) ;17, 19, 26, 27, 28
schedule("thepast", 0, 55, 26) ;17, 19, 26, 27, 28
schedule("forest", 0,10 )
schedule("elemental", 0, 60)
schedule("spindle", 0, 30, 11) ;11,21,22,23
schedule("earth", 0, 50)
schedule("cone", 0, 0.01) 
start("stereoRender") 		;render stereo file
start("ambiRender")		;render B-format file

instr forest 
Sample = sound("field", 3)
isusamp=0.2 ; max sustain volume
kamp =linseg(0,1,0.2,p3-(p3*0.1-1),isusamp,p3*0.1-1,0) 
kpitch=linseg(0.2,p3*0.5,0.7,p3*0.5,-0.2)
kstr=linseg(3.1, p3*0.5, 2, p3*0.5, 1)
kdens=20
kgrsize=0.3
iolaps = 2
agrainL, agrainR diskgrain Sample, kamp, kdens, kpitch, kgrsize, kstr, gi1, iolaps
kfiltmod=line(1500, p3, 3000)
afiltL, afiltR threepole agrainL, agrainR, kfiltmod, 0.1, 0.2
kdelay=0.4
kfb=0.4
kdpitch=linseg(1,p3,0.5)
kdelmix=0.4
adelL, adelR pdelay afiltL,afiltR,kdelay,kfb,kdpitch,kdelmix
kazim=line(0, p3, 2*360)
kalt=0
kdist=1;line(1,p3,0.5)
kout ambi_enc_dist adelL, giorder, kazim,kalt,kdist
al, ar declickst adelL, adelR
sbus_mix "master", al, ar
effect_mix "verbmix", al, ar, 0.6
;schedule(p1,p3,p3)
endin


instr elemental
irand = random(1,118) ;iranddur=random(0.2,9)
irandpitch=random(-2, 4)
Sample = sound("spire", 4)
Smachine = "grain"
idur =p3 
iampsus = 0.2	
iramp = p3*0.1
kamp=linseg(0, iramp, iampsus, p3-iramp*2, iampsus, iramp, 0)
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
	Sample = sound("soundbits", p4)
iampsus = 0.1
	iramp = p3*0.1
	kamp=linseg(0, iramp, iampsus, p3-iramp*2, iampsus, iramp, 0)
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
	iampsus =random(0.1,0.3) 
	iramp = p3*0.1
	kamp=linseg(0, iramp, iampsus, p3-iramp*2, iampsus, iramp, 0)
	irand=random(0.01, 10)
	irand2=random(0.01,20)
	kmod = linseg(irand, p3, irand2) ;create random modulator for VCO freq
	ipw =random(0.05, 0.93)
	amodfreq =vco2(kamp, kmod,4,ipw) 
	kfreq=random(90, 320)
	avco vco2 kamp, kfreq, 12
	asig=avco*amodfreq
	al declick asig
	reverb_mix(al, al, 0.8)
	kazim=line(0, p3, 4*360)
	kalt=lfo(40, 0.5)
	kdist=line(0.5,p3,1)
	kout ambi_enc_dist al, giorder, kazim,kalt,kdist
;	schedule(p1,p3,p3)
endin


instr cone 
	if sometimes(0.8, 1, 0) == 1 then
	iampsus =random(0.6,0.3) 
	iranddur=random(0.01, 2.7)
	kamp=expseg(iampsus, p3*iranddur, 0.001)
	irand=random(40, 170)
	ilambda=exprand(400)
	irand2=10+ilambda
	kmod = irand2 ;linseg(irand, p3*0.5, irand2) ;create random modulator for VCO freq
	ipw =random(0.05, 0.93)
	amodfreq =vco2(kamp, kmod,4,ipw) 
	kfreq=100+(exprand(300))
	avco vco2 kamp, kfreq, 12
	asig=avco*amodfreq
	kdelay=random(0.11, 3)
	kfb=0.6
	kdpitch init 1
	kdpitch+=lfo(0.01,20)
	kdelmix=0.2
	adelL, adelR pdelay asig,asig,kdelay,kfb,kdpitch,kdelmix
	kfiltmod=line(5000, p3, 500)
	kres = 0.5
	afiltL, afiltR threepole adelL, adelR, kfiltmod, kres, 0.2
	al, ar declickst afiltL, afiltR
	kazim=line(200, p3, 1.5*360)
	kalt=20
	kdist=line(0.2,p3,1)
	kout ambi_enc_dist al, giorder, kazim,kalt,kdist
	reverb_mix(al, al, 0.8)
endif
;	schedule(p1,p3,p3)
endin
instr thepast
	Sample = sound("soundbits", p4)
iampsus = 0.2
	iramp = p3*0.1
	kamp=linseg(0, iramp, iampsus, p3-iramp*2, iampsus, iramp, 0)
kfreq=linseg(20, p3, 30)
kpitch = 0.5;linseg(2.2, p3*0.33, 2.2, p3*0.56, 0.1)
kgrsize=0.1
kprate=1.0;random(-1, 3)
ifun = gi1
iolaps = 2
agrainL, agrainR diskgrain Sample, kamp, kfreq, kpitch, kgrsize, kprate, ifun, iolaps
al, ar declickst agrainL, agrainR
kverbmix=linseg(0.01, p3*0.5, 0.99, p3*0.5, 0.01)
reverb_mix(al,ar,0.7)
;schedule(p1, p3, p3)
endin

