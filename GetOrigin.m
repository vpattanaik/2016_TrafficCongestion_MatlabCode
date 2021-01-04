function Origin = GetOrigin(  )

h=msgbox('Please Select the Origin using the Left Mouse button');
uiwait(h,5);

if ishandle(h) == 1
    delete(h);
end

%xlabel('Please Select the Origin using the Left Mouse button','Color','black');
but=0;

while (but ~= 1) %Repeat until the Left button is not clicked
    [xval,yval,but]=ginput(1);
end

xval=floor(xval);
yval=floor(yval);

Origin(1,1)=xval;%X Coordinate of the Target
Origin(1,2)=yval;%Y Coordinate of the Target

end

