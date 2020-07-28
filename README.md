# CLQ_Spectra
Followup spectra published in MacLeod et al (2019) https://ui.adsabs.harvard.edu/abs/2019ApJ...874....8M/abstract

Directory followup_spectra contains each followup spectrum in ascii format

File models.fits contains fitting results from QSfit (see description below)

IDL code to make Table 3 (available in full in qsfit.tex): qsfitread.pro
  * Reads in above file models.fits

Input data files for qsfitread.pro: clqcans_info.dat, nohb.txt, nohb_sdss.txt

DESCRIPTION of models.fits:

The fits file contains the QSfit parameters for all the Magellan, MMT, and WHT objects. The following fields are listed in the header (see full list below).  

outpar1 lists the luminosity *change* of the power-law continuum component at 3240A, where Delta(L) = spectrum2 - spectrum1. The error associated with this change is listed in outpar4. 

outpar2 and outpar3 list the same thing as above but for the total Hbeta luminosity.  

Then, columns outpar21 -- outpar24 list the *luminosity* of those components for the first (SDSS) spectrum (rather than the change).  You can then get the luminosity for the second (followup) spectrum by adding the SDSS luminosity to Delta(L).

Columns outpar17 -- outpar20 and outpar 25 -- 28 list the MgII luminosity for Spectrum 1 (SDSS) and Spectrum 2, and the 2800A continuum for Spectrum 1 and 2.

Last column lists the flux conversion factor 4 pi r^2 in 10^59 cm^2, obtained by dividing output luminosity data array element by the input flux data array element, for the same wavelength bin width. 

Full column list:

ID
SPECNAME: name of spectral data file
norm    : resulting scaling factor for follow-up spectrum  (which I already sent)
outpar1 : Delta_L_continuum_3240A     
outpar2 : Delta_L_hbeta    
outpar3 : Delta_L_hbeta_err 
outpar4 : Delta_L_continuum_3240A_err                                                      
outpar5 : fwhm_narrow_hb1                                                           
outpar6 : fwhm_narrow_hb2                                                           
outpar7 : ignored                                                             
outpar8 : ignored                                                      
outpar9 : SNR                                                                 
outpar10: Alternate_SNR                                                                
outpar11: N_sigma_hbeta                                                            
outpar12: N_sigma_hbeta_max                                                        
outpar13: fwhm_broad_hbeta                                                            
outpar14: fwhm_err_br_hbeta                                                        
outpar15: fwhm_broad_hbeta2                                                           
outpar16: fwhm_err_broad_hbeta2                                                       
outpar17: L_mgii                                                                
outpar18: L_mgii_err
outpar19: L_continuum1_2800A 
outpar20: L_continuum1_err_2800A                  
outpar21: L_continuum1_3240A                                                               
outpar22: L_continuum1_3240A_err
outpar23: L_hbeta1                                                                 
outpar24: L_hbeta1_err              
outpar25: L_mgii2                                                               
outpar26: L_mgii2_err                                                           
outpar27: L_continuum2_2800A                                                            
outpar28: L_continuum2_err_2800A
outpar29: 4_pi_r2 
