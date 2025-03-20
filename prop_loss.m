function L=prop_loss(f,rho)

% L=ones([length(f),length(rho)]);
ones_vect=ones(size(f));
L=ones_vect*((rho.^(-1)));
L=L/max(L,[],'all');

end