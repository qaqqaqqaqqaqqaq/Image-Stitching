function [ result ] = theta( sin, cos )

if cos>0 && sin>0
    result = acos(cos)*180 /pi;
elseif cos<0 && sin>0
    result = acos(cos)*180 /pi;
elseif cos<0 && sin<0
    result = 180 - asin(sin) *180 /pi;
elseif cos>0 && sin<0
    result = asin(sin) *180 /pi;
elseif cos==0
    result = asin(sin) *180 /pi;
elseif sin==0
    result = acos(cos) *180 /pi;
end

end

