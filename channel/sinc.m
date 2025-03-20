function y=sinc(x)
y=(1-(x==0)).*sin(pi*x)./(pi*x);
end