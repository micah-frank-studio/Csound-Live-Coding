
gi1 ftgen 1,0,8192,20,2,1 ;Hanning Window
gi2 ftgen 2,0,64,-2,1,45,0,45,-5,0,0,0,0,0,0,0

gkmonitorMode init 0
/** B-Format - Ambisonic encoding options */ 
giorder = 5
gisizea = (giorder+1)^2
zakinit gisizea, 1    ;(isizea = (order + 1)^2)  /* higher  order encoder */
/* built in Csound 3rd order encoder */

/*
opcode mixencoded, 0, aakk
	ainL, ainR, kazimuth, kelev xin
	imixchn init 0 
	abenc[] init gisizea
	abenc bformenc1 ainL, kazimuth, kelev
	if imixchn<=gisizea then	
	Smxchn strcat "benc", S(imixchn)
	chnmix abenc[imixchn], Smxchn
	imixchn+=1
	endif 

	fout "mix.wav", 24, abenc
	aDecode[] init 2
	aDecode  bformdec1 1, abenc
	outs(aDecode[0], aDecode[1])
endop
*/
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
/*
;  up/down line mod. Takes arguments for lo range, hi range and freq
opcode linemod, k,iii 
	ilo, ihi, irate xin
	kmod=linseg(ilo, irate/2, ihi, irate/2, ilo)
	xout kmod
endop

; multi-segment modulator 
opcode segmod, k, iiioooooo
	ival, itime1, ival1, itime2, ival2, itime3, ival3, itime4, ival4	
	kline linseg ival, itime1, ival1, itime2, ival2, itime3, ival3, itime4, ival4
	xout kline
endop

opcode seq, 0, kiSSik[]k[]k[]k[]
	kamp, ichance, Sprocessor, Sample,idur, kparam1[], kparam2[], kparam3[], kparam4[] xin
	if (choose(ichance) == 1) then
		;Sample getSample Sfolder, isample ; get the sample name
		schedule(Sprocessor, 0, p3, Sample, kparam1[0], kparam1[1], kparam1[2], kparam2[0],kparam2[1],kparam2[2],kparam3[0],kparam3[1],kparam3[2],kparam4[0],kparam4[1],kparam4[2], kamp)
	endif
endop

*/

/** Starts running a named instrument for indefinite time using p2=0 and p3=-1. 
  Will first turnoff any instances of existing named instrument first.  Useful
  when livecoding always-on audio and control signal process instruments. */
;code by Steven Yi
/** Turns off running instances of named instruments.  Useful when livecoding
  audio and control signal process instruments. May not be effective if for
  temporal recursion instruments as they may be non-running but scheduled in the
  event system. In those situations, try using clear_instr to overwrite the
  instrument definition. */
instr KillImpl
  Sinstr = p4 
  if (nstrnum(Sinstr) > 0) then
    turnoff2(Sinstr, 0, 0)
  endif
  turnoff
endin

opcode kill, 0,S
  Sinstr xin
  schedule("KillImpl", 0, 0.01, Sinstr)
endop

opcode start, 0,S
  Sinstr xin
  if (nstrnum(Sinstr) > 0) then
    kill(Sinstr)
    schedule(Sinstr, ksmps / sr,-1)
  endif
endop

/** Stops a running named instrument, allowing for release segments to operate. */
opcode stop, 0,S
  Sinstr xin

  if (nstrnum(Sinstr) > 0) then
    schedule(-nstrnum(Sinstr), 0, 0)
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

opcode sbus_mix, 0,Saa
  Sbus, al, ar xin
	Sbusl strcat Sbus, "l"
	Sbusr strcat Sbus, "r"
	chnmix al, Sbusl
	chnmix ar, Sbusr
endop

;stereo effect send with mix amount
opcode effect_mix, 0,Saak
  Sbus, al, ar, kamount xin
	kamount=limit(kamount,0,0.99)
	Sbusl strcat Sbus, "l"
	Sbusr strcat Sbus, "r"
	chnmix al*kamount, Sbusl
	chnmix ar*kamount, Sbusr
endop

opcode sbus_get,aa,S
  Sbus xin
	Sbusl strcat Sbus, "l"
	Sbusr strcat Sbus, "r"
	abusl chnget Sbusl
	abusr chnget Sbusr
xout abusl, abusr
endop

; Clear audio signals from bus channel 
opcode sbus_clear, 0, S
	Sbus xin
  	Sbusl strcat Sbus, "l"
	Sbusr strcat Sbus, "r"
	chnclear Sbusl
	chnclear Sbusr
endop

opcode pdelay, aa, aakkkk 
	al,ar, kdelay, kfeedback, kfbpshift, kmix xin
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
endop

opcode threepole, aa,aakkk
	al, ar, kcf, kres, kdist xin
	kcf limit kcf, 10,16000 
	kres limit kres, 0.001, 0.999
	afl lpf18 al,kcf, kres, kdist
	afr lpf18 ar,kcf, kres, kdist
	xout afl, afr
endop
	
instr reverb
	ainL, ainR sbus_get "verbmix"
	kfblvl=0.6
	kfc=5000
	aRevL,aRevR reverbsc ainL, ainR, kfblvl, kfc
	sbus_mix "master", aRevL, aRevR
	iazimL = 270 
	iazimR = 90
	idist = 1
	kout ambi_enc_dist aRevL, giorder, iazimL, 0, idist ;encode reverb to 2 channels (what is distance unit?
	kout ambi_enc_dist aRevR, giorder, iazimR, 0, idist 
endin

instr stereoMonitor
	amixL, amixR sbus_get "master"
	outs amixL, amixR	
endin 

instr stereoRender
	allL, allR monitor
	Sdate dates
	Sdir = "renders/"
	Sfilename strcat Sdir,Sdate
	Sfilename strcat  Sfilename, ".wav"  
	fout Sfilename, 24, allL, allR ; create 24-bit .wav file in specified directory
endin

instr ambiMonitor
	aoutL, aoutR ambi_decode giorder, gi2 ;  stereo decoding
	outs aoutL, aoutR
endin
instr ambiRender
	k0 ambi_write_B "B_form.wav",giorder,24
	zacl 0, gisizea-1
endin

opcode  monitorMode, 0, i
	imonitorMode xin
	if imonitorMode == 1 then
		start("ambiMonitor")
		stop("stereoMonitor")
		prints "monitor mode = ambisonic\n"
	else
		start("stereoMonitor")
		stop("ambiMonitor")
		prints "monitor mode = stereo\n"
	endif
endop

instr clearChn
	sbus_clear "master"
	sbus_clear "verbmix"
	zacl 0, gisizea-1
endin
start("reverb")
start("clearChn")
monitorMode 0

