
monitorMode 0 	;0 = stereo, 1 = ambisonic
kill("theSwarm")
schedule("thepast", 0, 100, 8) 
schedule("forest", 0,1,0) ;0,3
schedule("elemental", 0, 200, 3) 	;1
schedule("spindle", 0, 2.5, 1, 0.9) ;30,21,22,38(raph) p5=pitch
schedule("earth", 0, 5.2, 275)	;p4=freq
schedule("cone", 0, 1.05) 
schedule("theSwarm",0,135,5)	;1,4,5

schedule("ambiRender",0,300)
start("stereoRender") 		;render stereo file

instr forest 
	Sample = sound("field", p3)
	isusamp=0.2 ; max sustain volume
	kamp =linseg(0,1,0.2,p3-(p3*0.1-1),isusamp,p3*0.1-1,0) 
	kpitch=random(-2, 2);linseg(0.9,p3*0.5,0.7,p3*0.5,-0.9)
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
	kazim=line(0, p3, 3*360)
	kalt=gauss(10)
	kdist=1;line(1,p3,0.5)
	kout ambi_enc_dist adelL, giorder, kazim,kalt,kdist
	al, ar declickst adelL, adelR
	sbus_mix "master", al, ar
	effect_mix "verbmix", al, ar, 0.6
	schedule(p1,p3,p3)
	krms=rms(al)
	krms*=5
	krms=random(1,10)
	makeOSC("forest",krms)
endin


instr elemental
	irand = random(1,118) ;iranddur=random(0.2,9)
	irandpitch=random(-2, 4)
	Sample = sound("tone", p4)
	Smachine = "grain"
	idur =p3 
	iampsus = 0.2	
	iramp = p3*0.1
	kamp=linseg(0, iramp, iampsus, p3-iramp*2, iampsus, iramp, 0)
	kpitch=0.5 ;linseg(0.9,p3,0.3)
	kstr=1;linseg(2.1, p3*0.5, 1, p3*0.5, 1)
	kdens=10
	kgrsize=0.2
				iL ftgen 0, 0, 0, 1, Sample, 0, 0, 1
				iR ftgen 0, 0, 0, 1, Sample, 0, 0, 2
	prints "Sample: %i %s Number: %i \n", p1, Sample,irand
	iolaps = 2
	ips     = 1/iolaps
		a1L syncloop kamp, kdens, kpitch, kgrsize, ips*kstr, 0, ftlen(iL)/sr, iL, 1, iolaps
		a1R syncloop kamp, kdens, kpitch, kgrsize, ips*kstr, 0, ftlen(iR)/sr, iR, 1, iolaps
	kfiltmod=line(4000, p3, 100)
	afiltL, afiltR threepole a1L, a1R, kfiltmod, 0.1, 0.2
	kdelay=0.4
	kfb=0.4
	kdpitch=linseg(1,idur, 0.5)
	kdelmix=0.4
;	adelL, adelR pdelay afiltL,afiltR,kdelay,kfb,kdpitch,kdelmix
	krandclock=(randh(abs(1.4),1)+1) 
	kazim=randi(gauss(90),krandclock,0)
	kalt=linseg(0,p3*0.5,90,p3*0.5, 0);randh(10, 2)
	kdist=2;linseg(0,p3*0.5,100,p3*0.5,0)
	al, ar declickst afiltL, afiltR
	kout ambi_enc_dist al+ar, giorder, kazim,kalt,kdist
	sbus_mix "master", al, ar
	effect_mix "verbmix", al, ar, 0.6
;schedule(p1,p3,p3)
endin

instr spindle
	Sample = sound("binbits", p4)
	iampsus = 0.2
	iramp = p3*0.1
	kamp=linseg(0, iramp, iampsus, p3-iramp*2, iampsus, iramp, 0)
	kfreq=linseg(10,p3*0.33,30,p3*0.66,10)
	kpitch =p5; linseg(0.2, p3*0.33, 2.2, p3*0.56, 0.01)
	kgrsize=0.3
	kprate=randi(3,3)+0.1
	ifun = gi1
	iolaps = 10
	agrainL, agrainR diskgrain Sample, kamp, kfreq, kpitch, kgrsize, kprate, ifun, iolaps
	al, ar declickst agrainL, agrainR
	kmove=line(0,p3,2*360)
	kazim=gauss(20)+kmove
	kalt=abs(randi(10,3))
	kdist=1
	kverbmix=0.9;linseg(0.11, p3*0.5, 0.99, 73*0.5, 0.31)
	kout ambi_enc_dist al+ar, giorder, kazim,kalt,kdist
	sbus_mix "master", al, ar
	effect_mix "verbmix", al, ar,kverbmix 
	;prints "Sample: %i %s Number: %i \n", p1, Sample,p4
	schedule(p1, p3, p3)
	krms=rms(al)
	krms*=5
	makeOSC("spindle",krms)
endin

instr earth
	iampsus =random(0.2,0.5) 
	iramp = p3*0.1
	kamp=linseg(0, iramp, iampsus, p3-iramp*2, iampsus, iramp, 0)
	irand=random(0.01, 40)
	irand2=random(0.01,0.1)
	kmod = irand2 ;linseg(irand, p3, irand2) ;create random modulator for VCO freq
	ipw =random(0.05, 0.93)
	amodfreq =vco2(kamp, kmod,4,ipw) 
	kfreq=random(190, 220)
	ipitch =random(80, 220)
	avco vco2 kamp*0.4, ipitch, 12
	asig=avco*amodfreq
	al declick asig
	sbus_mix "master", al, al
	effect_mix "verbmix", al, al, 0.8
	kazim=randi(270, 2)
	kalt=linseg(0,p3*0.5,0,p3*0.125,90,p3*0.125,0,p3*0.125,90,p3*0.125,0);lfo(40, 0.5)
	kdist=1;line(0.5,p3,1)
	kout ambi_enc_dist al, giorder, kazim,kalt,kdist
	makeOSC("earth", "earth")
;	schedule(p1,p3,p3)
endin


instr cone 
	if sometimes(0.8, 1, 0) == 1 then
	iampsus =random(0.3,0.2) 
	iranddur=1;abs(gauss(0.5))+0.12
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
	kdelmix=0.6
	adelL, adelR pdelay asig,asig,kdelay,kfb,kdpitch,kdelmix
	kfiltmod=line(5000, p3, 500)
	kres = 0.5
	afiltL, afiltR threepole adelL, adelR, kfiltmod, kres, 0.2
	al, ar declickst afiltL, afiltR
	kazim=randi(90,2);line(200, p3, 1.5*360)
	kalt=gauss(10)
	kdist=1
	kout ambi_enc_dist al, giorder, kazim,kalt,kdist
	sbus_mix "master", al, ar
	effect_mix "verbmix", al, ar, 0.8
endif
;	schedule(p1,p3,p3)
endin
instr thepast
	Sample = sound("tapes", p4)
	iampsus = 0.3
	iramp = p3*0.1
	kamp=linseg(0, iramp, iampsus, p3-iramp*2, iampsus, iramp, 0)
	kfreq=linseg(20, p3, 30)
	kpitch = 0.5;linseg(2.2, p3*0.33, 2.2, p3*0.56, 0.1)
	kgrsize=0.1
	kprate=random(-1, 3)
	ifun = gi1
	iolaps = 2
	agrainL, agrainR diskgrain Sample, kamp, kfreq, kpitch, kgrsize, kprate, ifun, iolaps
	kdelay= 0.5
	kfb = 0.3
	kdpitch=linseg(0.1, p3*0.5, 0.3, p3*0.5, 0.1)
	kdelmix=0.5
	adelL, adelR pdelay agrainL, agrainR, kdelay, kfb, kdpitch, kdelmix
	al, ar declickst agrainL, agrainR
	kazim=randi(90,0.2);line(200, p3, 1.5*360)
	kalt=gauss(50)
	kdist=1
	kout ambi_enc_dist al, giorder, kazim,kalt,kdist
	kverbmix = 0.8
	sbus_mix "master", al, ar
	effect_mix "verbmix", al, ar,kverbmix 
	;schedule(p1, p3, p3)
endin

instr theSwarm
	Sample = sound("tone",p4)
	idur = 0.5 ; duration of the swarm
	ksection =abs(rand(3,2)) ; offset seconds. Trick: make range longer than file length to create gaps
	ksizemin = 0.1 ;min size of each member of the swarm
	ksizemax = 0.6 ;max size of each member of the swarm
	iloopdur = 10
	kdensity loopseg 1/iloopdur, 0, 0, 20, iloopdur, 40, iloopdur, 2 ;thickness of swarm
	kprox =linseg(0.1,10,1) ;distance of the swarm ;scaled 0-1
	kmotion = 0.04;abs(randh(0.7,0.01,2)) ; how fast does the swarm move around (in hz)
	swarm Sample,ksection,ksizemin,ksizemax,kdensity,kprox,kmotion
	asL, asR sbus_get "swarm"
	kazim=lfo(360,1/(p3*0.33))
	kdelay = 0.2
	kfb=0.4
	kdpitch = 2
	kdelmix=0.8
	adelL, adelR pdelay asL, asR,kdelay,kfb,kdpitch,kdelmix
	kalt=gauss(30)
	kdist=1
	kout ambi_enc_dist adelL+adelR, giorder, kazim,kalt,kdist
	sbus_mix "master",adelL, adelR 
	effect_mix "verbmix", adelL, adelR,0.9
	sbus_clear "swarm"
endin

instr monster1
	ibpm=100
	imaxamp=0.5
	idensity=0.7 ;1 is more dense, 0.9 less
	imaxreso=0.2	;maximum filter reso
	imaxcf = 9300
	iscaleselect = 1 ; 0= major scale, 1=minor, 2=wholetone
	iwaveSwitch1 =0 ; 0=waveform is static, 1= waveform is dynamic
	iwaveSwitch2 =0
	iOctaveSelect = 4 ;octave range of selection
	iRing = 1; 0=two oscillators are mixed, 1=2 osc are ring modulated
	schedule("radrainbow",0,1, ibpm,imaxamp, idensity, imaxcf, imaxreso, iscaleselect,iwaveSwitch1, iwaveSwitch2,iOctaveSelect, iRing)
	ainL, ainR sbus_get "radrainbow"
	sbus_mix "master", ainL, ainR
	effect_mix "verbmix", ainL, ainR, 0.8
	sbus_clear("radrainbow")
endin

