/* RadRainbow - algorithmic synth line generator for Csound Live Coding
		By Micah Frank
*/

gi1 ftgen 1,0,129,10,1 ;sine
gi2 ftgen 2,0,129,10,1,0,1,0,1,0,1,0,1 ;odd partials
gi3 ftgen 3, 0, 16384, 10, 1, 0 , .33, 0, .2 , 0, .14, 0 , .11, 0, .09 ;odd harmonics
gi4 ftgen 4, 0, 16384, 10, 0, .2, 0, .4, 0, .6, 0, .8, 0, 1, 0, .8, 0, .6, 0, .4, 0,.2 ; saw
gi5 ftgen 6,0,257,9,.5,1,270,1.5,.33,90,2.5,.2,270,3.5,.143,90;sinoid
gi6 ftgen 7,0,129,9,.5,1,0 ;half sine
gi7 ftgen 8,0,129,7,1,64,1,0,-1,64,-1 ;square wave
gi8 ftgen 9,0,129,7,-1,128,1 ;actually natural
gi9 ftgen     0, 0, 2^10, 10, 1, 0, -1/9, 0, 1/25, 0, -1/49, 0, 1/81
gi10 ftgen     0, 0, 2^10, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1

gkseq init 0
opcode rainbow,0,k
	kstate xin
	if kstate == 0 then
		turnoff2("radrainbow", 0,1)
	endif
endop

instr radrainbow 
	ibpm=p4 
	imaxamp=p5
	idensity=p6
	imaxcf=p7
	imaxreso=p8
	iscaleselect=p9
	iwaveSwitch1=p10
	iwaveSwitch2=p11
	iOctaveSelect=p12
	iRing=p13 
anoise noise 0.1, 0.5
kenv=linseg(1,0.2,0)
iwaveSelect1 = round(linrand(9))
iwaveSelect2 = round(linrand(9))

iCounter init 0
isteps random 32, 64
restart:
; generate a random numbers to use later
;iGaussRange = rnd(1)
iRand random 0, 1
iRand2 = int(rnd(3))
iRand3 random 0,1

if iOctaveSelect = 0 then
	ioctave = 0
	else 
	ioctaveSwitcher random -1,1
	ioctave = round (ioctaveSwitcher)
endif

; choose a definite pitch for the note, basing the choice on the random number: 

if iscaleselect==0 then
	inoteArray[] fillarray 6.0, 6.02, 6.04, 6.05, 6.07, 6.09, 6.11 ;major scale
elseif iscaleselect==1 then
	inoteArray[] fillarray 6.0, 6.02, 6.03, 6.05, 6.07, 6.09, 6.10 ;minor scale
elseif iscaleselect==2 then
	inoteArray[] fillarray 6.0, 6.02, 6.04, 6.06, 6.08, 6.10, 6.10 ;wholetone scale
endif

irandomNoteSelect = int(rnd(7))

ifreq = cpspch (inoteArray[irandomNoteSelect]+ ioctave)

;;create durations for score execution

idurArray[] fillarray 0.25,0.33,0.25,0.5,0.75, 1.0, 1.5,2.0 ;make a selection of time divisions

idurArrayselect1 random 0,7 ; create array selector 
idurArrayselect2 random 0,7

iDurSelection1 = idurArray[round(idurArrayselect1)] ; choose item in array with arraySelector rounded

iDurSelection2 = idurArray[round(idurArrayselect2)]

ibeatrate = 60/ibpm
iDuration1 = ibeatrate*iDurSelection1

iDuration2 = ibeatrate*iDurSelection2

;choose the longer duration for control sequence

iTotalDuration init 0 
iTotalDuration = (iDuration1  > iDuration2 ? iDuration1 : iDuration2)

kDuration = iTotalDuration ; convert to krate

irandAmp random imaxamp-0.2, imaxamp
iRandFilter random 250, imaxcf
iRandQ random 0.1,imaxreso


; select if waveform 1 selection is static or it remains constant
itablearray [] fillarray gi1,gi2,gi3,gi4,gi5,gi6,gi7,gi8,gi9,gi10

if iwaveSwitch1 == 1 then ;waveform is dynamic
	ichooseTable random 0,9
	ichooseTableround = round(ichooseTable) 
	ifn1 = itablearray[ichooseTableround] ;each pass selects a random table
	;prints "waveform1 is dynamic\n"
else 
	ifn1 = itablearray[iwaveSelect1] ;waveform is static throughout
	;prints "waveform1 is static\n"
endif

; select if waveform 2 selection is static or it remains constant
if iwaveSwitch2 == 1 then
	ichooseTable random 0,9
	ichooseTableround = round(ichooseTable) 
	ifn2 = itablearray[ichooseTableround] ;each pass selects a random table
	;prints "waveform2 is dynamic\n"
else 
	ifn2 = itablearray[iwaveSelect2] ;waveform is static throughout
	;prints "waveform2 is static\n"
endif

; does this step make a sound or not?

iatk = 0.005
irel = 0.01
if iRand3 > idensity then
	aenv1 linsegr irandAmp, iDuration1, 0, irel, 0
	aenv2 linsegr irandAmp, iDuration2, 0, irel, 0 
else
	aenv1 linen 0, 0, 0, 0
	aenv2 linen 0, 0, 0, 0
endif

;print iDuration1, iDuration2, iTotalDuration
ifilterinit random 0.0, 1
ifilterfinal random 0.0, 1

kfilterenv linseg 0.0, iatk, ifilterinit, iTotalDuration-iatk, ifilterfinal

awave1 oscili aenv1, ifreq, ifn1
;print ifn1
awave2 oscili aenv2, ifreq, ifn2

if iRing == 0 then ;summed
	aWaves = awave1 + awave2 
	else
	aWaves = awave1 * awave2 ;ring modulated
endif

asig moogladder aWaves, iRandFilter*kfilterenv, iRandQ

;;schedule note
ktrig metro ibeatrate*0.25 ;trigger 16th notes
if ktrig != 0 && gkseq==1 then
	event "i","radrainbow", ibeatrate*0.25,kDuration,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13
	iCounter += 1
endif	
print gkseq
al clip asig, 0, 0.7  ;clip any weird filter anomalies

/*if iCounter == isteps then
	prints "last step"
	afadeout linseg irandAmp, ibeatrate-0.01, irandAmp, 0.01, 0 ;fadeout last 5ms of last loop - think this is working. not entirely sure ;)
	sbus_mix "radrainbow",al*afadeout,al*afadeout
else*/
sbus_mix "radrainbow", al, al
outs al, al
endin
