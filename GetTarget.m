function Target = GetTarget(  )

h=msgbox('Please Select the Target using the Left Mouse button');
uiwait(h,5);

if ishandle(h) == 1
    delete(h);
end

%xlabel('Please Select the Target using the Left Mouse button','Color','black');
but=0;

while (but ~= 1) %Repeat until the Left button is not clicked
    [xval,yval,but]=ginput(1);
end

xval=floor(xval);
yval=floor(yval);

Target(1,1)=xval;%X Coordinate of the Target
Target(1,2)=yval;%Y Coordinate of the Target

end

