
function G=G_f_phi(f,phi,b,L)
%f is a scalar, phi [rad] can be multi-dimantional size [1,#radians]

% f can be size [#frecs,1]
Lmin=10*10^(-3);
c=3*10^8;
k0=2*pi*f/c; %[40,1]
betta=k0.*sqrt(1-((c./(2*b*f)).^2));
ones_vect=ones(1,length(phi));
arg=L./2.*(betta*ones_vect-k0*cos(phi));
G=(L/Lmin)*sinc(arg);   % sinc defined sin(pi*x)/(pi*x)
% G=sinc(arg);

end