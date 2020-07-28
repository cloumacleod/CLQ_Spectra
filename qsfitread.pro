pro qsfitread
;Write table of QSfit results for paper (MacLeod et al 2019)
frac = 0
lambda = 3240
clqconf = 3

f=mrdfits('models.fits',1,header)
nqso = n_elements(f.id)

;Get DR7 Eddington ratios, full IDs, etc:
readcol,'clqcans_info.dat',f='A,D,D,D,D,D,X,X,X,D', /silent,$
        SDSSJID, ra, dec, z, $
        gmag, gmag_error, $
        CLQflag, radioflag, logL5100, logMBH, logEdd_ratio, LOGL_OIII_5007

jid='J'+strmid(sdssjid,0,6)
match,f.id,jid,m1,m2
sorted=sort(m1)
m1 = m1[sorted] & m2 = m2[sorted]
idfull = strarr(nqso)
idfull[m1] = 'J'+sdssjid[m2]
;Match to vis. insp. CLQ list and define clqs to be only those with high Nsigma:
mclq=where(clqflag[m2] eq 1 and f[m1].outpar12 ge clqconf,nclq)
print,f[m1[mclq]].id,nclq



nohbflag                 = intarr(n_elements(f.id))
nohbflag_sdss            = intarr(n_elements(f.id))
add                      = strarr(n_elements(f.id))
add_sdss                 = strarr(n_elements(f.id))

readcol,'nohb.txt',f='A,D',$
        idnohb, hb_br_fwhm, hb_br_fwhm_err, hb_br_voff, hb_br_voff_err
match,f.id,idnohb,m1nohb,m2nohb
if m1nohb[0] ne -1 then  begin
   nohbflag[m1nohb] = 1
   add[m1nohb] = '<'
endif
readcol,'nohb_sdss.txt',f='A,D',$
         idnohb, hb_br_fwhm, hb_br_fwhm_err, hb_br_voff, hb_br_voff_err
match,f.id,idnohb,m1nohb,m2nohb
if m1nohb[0] ne -1 then  begin
   nohbflag_sdss[m1nohb] = 1
   add_sdss[m1nohb] = '<'
endif

; Now I've matched to lists with upper limits.  Mark them in
;the Table as limits using 'add' string.

;------------ Write table for paper:
if frac eq 0 then begin
  l1   = f.outpar21; L_cont1 (@ lambda)  
  l1e  = f.outpar22
  l2   = f.outpar1+l1; L_cont2 (3240A) 
  l2e  = sqrt( f.outpar4^2. -  l1e^2.)
  lhb1 = f.outpar23; L_Hbeta1 
  lhb1e= f.outpar24_scalingoiii_errs_nounk_mc100_byeye2_3240_CLQ3rebin
  lhb2 = f.outpar2+lhb1; L_Hbeta2 
  lhb2e= sqrt( f.outpar3^2. -  lhb1e^2.)
;Sort by RA:
  sorted = sort(f.id)  
  idfull=idfull[sorted]
  l1   = l1   [sorted]
  l1e  = l1e  [sorted]
  l2   = l2   [sorted]
  l2e  = l2e  [sorted]
  lhb1 = lhb1 [sorted]
  lhb1e= lhb1e[sorted]
  lhb2 = lhb2 [sorted] 
  lhb2e= lhb2e[sorted]
  nohbflag       = nohbflag      [sorted]
  nohbflag_sdss  = nohbflag_sdss [sorted]
  add            = add           [sorted]
  add_sdss       = add_sdss      [sorted]

  formatstring = $
     '(A,2x,'  +'A,'+ $
     'F6.1,2x,'+'A,'+ $
     'F4.1,2x,'+'A,'+ $
     'A,'           + $
     'F5.2,2x,'+'A,'+ $
     'F4.2,2x,'+'A,'+ $
     'F6.1,2x,'+'A,'+ $
     'F4.1,2x,'+'A,'+ $
     'A,'           + $
     'F5.2,A,'+ $  
     'F4.2,A)'  
  openw,3,'qsfit.tex'
  printf,3,'\floattable                                                                                          '
  printf,3,'\begin{deluxetable}{crrrrrrrr}                                                                       '
  printf,3,'\rotate%centering                                                                                    '
  printf,3,'\tablecaption{Spectral Decomposition\label{tab:qsfit}}                                               '
  printf,3,'\tablecolumns{9}                                                                                     '
  printf,3,'\tablewidth{0pt}                                                                                     '
  printf,3,'\tablehead{                                                                                          '
  printf,3,'\colhead{SDSSJID } & \colhead{ $L_{\rm 3240,SDSS} $}  &  \colhead{Error in $L_{\rm 3240,SDSS} $} &   '
  printf,3,'\colhead{ $L_{\rm H\beta,SDSS} $ } & \colhead{Error in $L_{\rm H\beta,SDSS} $ } &                    '
  printf,3,'\colhead{ $L_{\rm 3240,2} $} & \colhead{Error in  $L_{\rm 3240,2} $} &                               '
  printf,3,'\colhead{ $L_{\rm H\beta,2} $ } & \colhead{Error in $L_{\rm H\beta,2} $} \\                          '
  printf,3,'\colhead{ } & \colhead{ $ (10^{42} {\rm ~erg~s}^{-1})$}  &  \colhead{$(10^{42} {\rm ~erg~s}^{-1})$} &'
  printf,3,'\colhead{ $(10^{42} {\rm ~erg~s}^{-1})$ } & \colhead{ $(10^{42} {\rm ~erg~s}^{-1})$} &               '
  printf,3,'\colhead{ $(10^{42} {\rm ~erg~s}^{-1})$}  & \colhead{ $(10^{42} {\rm ~erg~s}^{-1})$} &               '
  printf,3,'\colhead{ $(10^{42} {\rm ~erg~s}^{-1})$ } & \colhead{ $(10^{42} {\rm ~erg~s}^{-1})$} \\              '  
  printf,3,'}                                                                                                    '
  printf,3,'\startdata                                                                                           '

  for i=0,nqso-1 do printf,3,f=formatstring,$
                           idfull[i]    ,'& ',$
                           l1   [i]    ,'& ',$
                           l1e  [i]    ,'&$',$
                           add_sdss[i],lhb1 [i]    ,'$&  ',$
                           lhb1e[i]    ,'& ',$
                           l2   [i]    ,'& ',$
                           l2e  [i]    ,'&$',$
                           add[i],lhb2 [i]    ,'$&  ',$
                           lhb2e[i]    ,'  \\'
  
  printf,3,'\enddata                                                                                '
  printf,3,'\tablecomments{The subscript "SDSS" denotes the earlier epoch, SDSS spectrum, and the subscript "2" denotes the follow-up spectrum. The full list of 109 fits are available in the electronic version.}'
  printf,3,'\end{deluxetable}                                                                       '
  
  close,3
endif
print,'Table finished'



stop
end
