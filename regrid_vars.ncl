;************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/popRemap.ncl"
;************************************
begin

dir = "/glade/p/work/che43/projects/ice_diag_cesm/"
filein = "isop.nc"
fileout = "isop_rgd.nc"
system("rm -f " + dir + fileout)
f0 = addfile(dir + filein, "r")
f1 = addfile(dir + fileout, "c")
setfileoption(f1,"Format","LargeFile")

vars = (/"isoiceint001","isoiceint0002","isoiceint003",\
        "isoicessl001","isoicessl002","isoicessl003"/)




C14 = f0->ABIO_D14CICEocn
filedimdef(f1,"time",-1,True) 
printVarSummary(C14)

; regriding
tgrid1 = where(.not.ismissing(C14),1.,0.)
C14_rgd = PopLatLon(C14, "gx1v6", "1x1d", "bilin", "da", "100716")
rmapgd = PopLatLon(tgrid1, "gx1v6", "1x1d", "bilin", "da", "100716")
rmapgd = where(rmapgd.eq.0, rmapgd@_FillValue, rmapgd)

lon = fspan(0.5,359.5,360)
lat = fspan(-89.5,89.5,180)
time = f0->time
z_t = f0->z_t

C14_rgd = (/C14_rgd/rmapgd/)
printVarSummary(C14_rgd)
C14_rgd!0 = "time"
C14_rgd!1 = "z_t"
C14_rgd!2 = "lat"
C14_rgd!3 = "lon"
C14_rgd&time = C14&time
C14_rgd&z_t = C14&z_t
C14_rgd&lat = lat
C14_rgd&lon = lon
printVarSummary(C14_rgd)

;saving
;f1->z_t = z_t
;f1->time = time
;f1->lat = lat
;f1->lon = lon
f1->ABIO_D14CICE = C14_rgd

end
