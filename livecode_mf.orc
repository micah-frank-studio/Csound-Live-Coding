
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
opcode trilfo, k,iii
	ilo, ihi, irate xin
	kmod=linseg(ilo, irate*0.5, ihi, irate*0.5, ilo)
	xout kmod
endop

opcode sbus_set, 0,Saa
  Sbus, al, ar xin
	Sbusl strcat Sbus, "l"
	Sbusr strcat Sbus, "r"
	chnset al, Sbusl
	chnset ar, Sbusr
endop

opcode sbus_get,aa,S
  Sbus xin
	Sbusl strcat Sbus, "l"
	Sbusr strcat Sbus, "r"
	abusl chnget Sbusl
	abusr chnget Sbusr
xout abusl, abusr
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
	iout = icointoss > 0.5 ? ival : idefault
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

instr grain
Sname = p4
kpitch=trilfo(p5,p6,p7)
kstr=trilfo(p8,p9,p10) 
kdens=trilfo(p11,p12,p13)
kgrsize=trilfo(p14,p15,p16)
kamp=0.2
ichn filenchnls Sname ;get number of channels. if mono then load up chn 1 twice.
		if ichn = 2 then
			giL ftgen 0, 0, 0, 1, Sname, 0, 0, 1
			giR ftgen 0, 0, 0, 1, Sname, 0, 0, 2
			prints "is stereo \n"
		else 
			giL ftgen 0, 0, 0, 1, Sname, 0, 0, 1	
			giR ftgen 0, 0, 0, 1, Sname, 0, 0, 1
		endif
iolaps = 2
ips     = 1/iolaps
	a1L syncloop kamp, kdens, kpitch, kgrsize, ips*kstr, 0, ftlen(giL)/sr, giL, 1, iolaps
;sbus_set("grain", agrainL, agrainR)
	a1R syncloop kamp, kdens, kpitch, kgrsize, ips*kstr, 0, ftlen(giR)/sr, giR, 1, iolaps
outs(a1L, a1R)
endin





