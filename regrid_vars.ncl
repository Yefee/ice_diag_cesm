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
filedimdef(f1,"time",-1,True) 


vars = (/"isoiceint001","isoiceint002","isoiceint003",\
        "isoicessl001","isoicessl002","isoicessl003"/)
n_vars = dimsizes(vars)

do n = 0, n_vars-1

    dat = f0->$vars(n)$
    printVarSummary(dat)

    ; regriding
    tgrid1 = where(.not.ismissing(dat),1.,0.)
    dat_rgd = PopLatLon(dat, "gx1v6", "1x1d", "bilin", "da", "100716")
    rmapgd = PopLatLon(tgrid1, "gx1v6", "1x1d", "bilin", "da", "100716")
    rmapgd = where(rmapgd.eq.0, rmapgd@_FillValue, rmapgd)
    lon = fspan(0.5,359.5,360)
    lat = fspan(-89.5,89.5,180)
    time = f0->time

    dat_rgd = (/dat_rgd/rmapgd/)
    printVarSummary(dat_rgd)

    dat_rgd!0 = "time"
    dat_rgd!1 = "lat"
    dat_rgd!2 = "lon"

    dat_rgd&time = dat&time
    dat_rgd&lat = lat
    dat_rgd&lon = lon

    ;saving

    f1->$vars(n)$ = dat_rgd


end do 
end
