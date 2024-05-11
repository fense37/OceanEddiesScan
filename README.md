# OceanEddiesScan (Your good friend to scan eddies in sea surface height field)

based on the Chelton SSH method(Chelton et al., 2011)

# Third Edition

2024.4.27

## OES version 0.1.2

- fixed some bugs
- Add the contour info of the eddy, the edge of the eddies now will produce.

# Second Edition

2024.4.22

## OES version 0.1.1

- Add the Thermo Dynamic Scan, which is used to judge if the eddies is a warm or cold core.
- fixed some bugs.
- Note: while using the field which longtitude is uncontinuous, make it continuous in your certain field.

# First Edition

2024.4.15

I GIVE U THE FIRST EDITION!

## OceanEddiesScan(OES) version 0.1.0

within:

## eddiesScan.m

the eddies scan function, with input eddiesScan(ssh, lat, lon, dates).

I scan every day's ssh, by using the singleSliceScan.m in the utils, then use eddyTrack.m to combine them.

I will explain these funcitions in utils later.

## test:

some test function to test the function eddiesScan.m, contourData.m and singleSliceScan.m

I recommod eddyScanTest to check if the main function of the project eddiesScan works.

## test data:

some ssh data, that I stole from the other project called OceanEddies, their one is pretty complicate, so I created my own one.

## utils

all the function use in eddiesScan.m

some functions here can be able to used in other project:

### calCirAver(field, lat, lon, center, r)

I haven't use it yet, it's a function return the points average field value on the circle u give by center and r

### contourData(field, lat, lon)

It's a good function gives u the field contour information, and returns a struct of every contour.

the struct is more readable than the return value of contourData, but it is also the reason for a low speed in the project

### dLatLon(lat1, lat2, lon1, lon2)

return the distance on spherical surface, by calculating the angle between two vectors and times Earth radius with it.

### eddyTrack(oldEddy, newEddy, date)

to update the eddy set by using the s value:

$$
s = \sqrt{(\frac{\Delta a}{a_0})^2+(\frac{\Delta d}{d_0})^2+(\frac{\Delta A}{A_0})^2} 
$$

which a is area, d is distance, and A is ampltitude. To connact the smallest s value of oldEddy.

### singleSliceScan(ssh, lat, lon)

to scan a single slice, but u can also use eddiesScan to do that

### I dont wanna introduce the rest, I'm tired and I wanna sleep. Good day, sir.
