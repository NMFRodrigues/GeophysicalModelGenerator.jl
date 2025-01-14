# This provides functions to load and save GeoData structs & friends to file
using JLD2, Downloads

export save_GMG, load_GMG

"""
    save_GMG(filename::String, data::Union{GeoData, CartDat, UTMData}; dir=pwd())
Saves the dataset `data` to a JLD2 `file` (name without extension) in the directory `dir`

Example
====
```julia
julia> Lon3D,Lat3D,Depth3D = LonLatDepthGrid(1.0:3:10.0, 11.0:4:20.0, (-20:5:-10)*km);
julia> Data_set    =   GeophysicalModelGenerator.GeoData(Lon3D,Lat3D,Depth3D,(DataFieldName=Depth3D,))   
julia> save_GMG("test",Data_set)
```
"""
function save_GMG(filename::String, data::Union{GeoData, CartData, UTMData}; dir=pwd())
    file_ext = joinpath(dir,filename*".jld2")
    jldsave(file_ext; data)

    return nothing
end 

"""
    load_GMG(filename::String, dir=pwd())

Loads a `GeoData`/`CartData`/`UTMData` data set from jld2 file `filename`
Note: the `filename` can also be a remote `url`, in which case we first download that file to a temporary directory before opening it

Example 1 - Load local file
====
```julia
julia> data = load_GMG("test")
GeoData 
  size      : (4, 3, 3)
  lon       ϵ [ 1.0 : 10.0]
  lat       ϵ [ 11.0 : 19.0]
  depth     ϵ [ -20.0 : -10.0]
  fields    : (:DataFieldName,)
  attributes: ["note"]
```

Example 2 - remote download
====
```julia
julia> url  = "https://seafile.rlp.net/f/10f867e410bb4d95b3fe/?dl=1"
julia> load_GMG(url)
GeoData 
  size      : (149, 242, 1)
  lon       ϵ [ -24.875 : 35.375]
  lat       ϵ [ 34.375 : 71.375]
  depth     ϵ [ -11.76 : -34.7]
  fields    : (:MohoDepth,)
  attributes: ["author", "year"]
```

"""
function load_GMG(filename::String, dir=pwd())

    if contains(filename,"http")
        #download remote file to a local temporary directory
        file_ext = Downloads.download(filename, joinpath(pwd(),"download_GMG_temp.jld2"))
    else
        # local file
        file_ext = joinpath(dir,filename*".jld2")
    end

    # load data:
    data =  load_object(file_ext)

    return data
end 
