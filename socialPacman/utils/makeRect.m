function rec = makeRect(X,Y,radius)
radius = radius/2;
rec = round([X-radius,Y-radius,X+radius,Y+radius]);
end