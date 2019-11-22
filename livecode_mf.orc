
gi1 ftgen 1,0,8192,20,2,1 ;Hanning Window

opcode declickst, aa, aa
ainL, ainR     xin
aenv    linseg 0, 0.02, 1, p3 - 0.05, 1, 0.02, 0, 0.01, 0
        xout ainL * aenv, ainR * aenv         ; apply envelope and write output
        endop

opcode makeOSC, 0, 0
	kwhen = 1
	Shost = ""
	iport = 3333
	Saddress = "/play2" 
	Stype = "ss"  ; "bcdfilmst" which stand for Boolean, character, double, float, 32-bit integer, 64-bit integer, MIDI, string and timestamp.
	Sdata1 = "stone" 
	Sdata2 = "glass" 
	OSCsend kwhen, Shost, iport, Saddress, Stype,Sdata1,Sdata2 
endop

; triangle LFO. Takes arguments for lo range, hi range and freq
opcode linemod, k,iii
	ilo, ihi, irate xin
	kmod=linseg(ilo, irate*0.5, ihi, irate*0.5, ilo)
	xout kmod
endop


opcode seq, 0, iSSik[]k[]k[]k[]
	ichance, Sprocessor, Sample,idur, kparam1[], kparam2[], kparam3[], kparam4[] xin
	if (choose(ichance) == 1) then
		;Sample getSample Sfolder, isample ; get the sample name
		schedule(Sprocessor, 0, idur, Sample, kparam1[0], kparam1[1], kparam1[2], kparam2[0],kparam2[1],kparam2[2],kparam3[0],kparam3[1],kparam3[2],kparam4[0],kparam4[1],kparam4[2])
	endif
endop

opcode sometimes,i,iii
	ichance, ival, idefault xin
	iout init 0
	icointoss = random(0,1)		
	iout = icointoss < ichance ? ival : idefault
	xout iout
endop

; when given a Folder name it will index files by number. wraps around if it exceeds bounds
gSoundsdir = "samples/"
opcode sound,S,Si
	Sfolder, inum xin
	Sdir1 strcat gSoundsdir, Sfolder 
	SFiles[] directory Sdir1
	ilen=lenarray(SFiles)
	iselect = (int(inum)) % ilen    ;protect array length and prohibit floats
	Soundfile = SFiles[iselect]
xout Soundfile
endop

;; Mixer

opcode busmix, 0,Saa
  Sbus, al, ar xin
	Sbusl strcat Sbus, "l"
	Sbusr strcat Sbus, "r"
	chnmix al, Sbusl
	chnmix ar, Sbusr
endop

opcode sbus_get,aa,S
  Sbus xin
	Sbusl strcat Sbus, "l"
	Sbusr strcat Sbus, "r"
	abusl chnget Sbusl
	abusr chnget Sbusr
xout abusl, abusr
endop

/** Clear audio signals from bus channel */
opcode sbus_clear, 0, S
	Sbus xin
  	Sbusl strcat Sbus, "l"
	Sbusr strcat Sbus, "r"
	chnclear Sbusl
	chnclear Sbusr
endop

opcode render, 0, S
	Schn xin
	al, ar sbus_get Schn
	outs(al,ar)
	sbus_clear(Schn)
endop

opcode pdelay, aa, Skkkk 
	Schn, kdelay, kfeedback, kfbpshift, kmix xin
	al, ar sbus_get Schn
	imaxdelay = 3; seconds
	alfoL lfo 0.05, 0.2 ; slightly mod the left delay time
	abuf1		delayr	imaxdelay
	atapL  deltap3    kdelay+alfoL
	delayw  al+ (atapL * kfeedback)
	fftinL  pvsanal   atapL, 1024, 256, 1024, 1 ; analyse it
	ftpsL  pvscale   fftinL, kfbpshift, 1, 2          ; transpose it keeping formants
	atpsL  pvsynth   ftpsL                     ; resynthesis
	
	;delay R
	alfoR lfo 0.05, 0.1 ; slightly mod the right delay time
	abuf2		delayr	imaxdelay
	atapR  deltap3    kdelay+alfoR
	delayw  ar + (atapR * kfeedback)
	fftinR  pvsanal   atapR, 1024, 256, 1024, 1
	ftpsR  pvscale   fftinR, kfbpshift, 1, 2          
	atpsR  pvsynth   ftpsR                    
	amixL=ntrpol(al, atpsL, kmix)
	amixR=ntrpol(ar, atpsR, kmix)
	xout amixL, amixR 
	;outs(amixL, amixR)
	sbus_clear(Schn)
endop

opcode reverb_mix, 0, aak
  al, ar, krvb xin
    sbus_mix(0, al, ar)
    sbus_mix(1, al * krvb, ar * krvb)
endop

instr grain
Sname = p4
kpitch=linemod(p5,p6,p7)
kstr=linemod(p8,p9,p10) 
kdens=linemod(p11,p12,p13)
kgrsize=linemod(p14,p15,p16)
kamp=0.5
ichn filenchnls Sname ;get number of channels. if mono then load up chn 1 twice.
		if ichn = 2 then
			iL ftgen 0, 0, 0, 1, Sname, 0, 0, 1
			iR ftgen 0, 0, 0, 1, Sname, 0, 0, 2
		;	prints "is stereo \n"
		else 
			iL ftgen 0, 0, 0, 1, Sname, 0, 0, 1	
			iR ftgen 0, 0, 0, 1, Sname, 0, 0, 1
		endif
iolaps = 2
ips     = 1/iolaps
	a1L syncloop kamp, kdens, kpitch, kgrsize, ips*kstr, 0, ftlen(iL)/sr, iL, 1, iolaps
	a1R syncloop kamp, kdens, kpitch, kgrsize, ips*kstr, 0, ftlen(iR)/sr, iR, 1, iolaps
;outs(a1L, a1R)
;sbus_mix("grain", a1L, a1R)
busmix("grain", a1L, a1R)
endin



