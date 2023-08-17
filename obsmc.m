function [Wobsmc,ueq3,Pobsmc,Lobsmc] = obsmc(Asigma,Bsigma, Csigma,Kg,u,xe)
    %%Observer based sliding mode control for DC-DC converters with integral term
    A1 =  Asigma{1,1};
    A2 =  Asigma{1,2};
    B1 = Bsigma{1,1};
    B2 = Bsigma{1,2};
    C1 = Csigma{1,1};
    C2 = Csigma{1,2};
    xe1 = xe(1);
    xe2 = xe(2);
    xeaug = [xe;0];
    A1tilde = [[A1;[0 1]],[0;0;0]];
    A2tilde = [[A2;[0 1]],[0;0;0]];
    B1tilde = [B1;-xe2/u];
    B2tilde = [B2;-xe2/u];
    C1tilde = blkdiag(C1,1);
    C2tilde = blkdiag(C2,1);
    deltaAtilde = A1tilde - A2tilde;
    P = blkdiag(1/deltaAtilde(1,2),-1/deltaAtilde(2,1),1);
    W = sdpvar(3,3);
    L = sdpvar(3,1,'full');
    %W = L*Kg
    tol = 10^-5; 
    opts=sdpsettings('solver','sedumi','verbose',0);
    restr = [A1tilde*P + P*A1tilde - W'*P - P*W<= -tol, W >= tol];
    [~,W] = solvelmi(W,restr,[],opts,'Observer gain W found.');
    restr = [A1tilde*P + P*A1tilde - Kg'*L'*P - P*L*Kg<= -tol];
    [~,L] = solvelmi(L,restr,[],opts,'Observer gain L found.');
   %ueq3 = 1 + inv(Kg*deltaAtilde*xeaug)*Kg*((A1tilde-L*Kg)*xeaug + B1tilde*u + L*Kg*xeaug);
   ueq3 = 1 + inv(Kg*deltaAtilde*xeaug)*Kg*((A2tilde-W)*xeaug + B2tilde*u + W*xeaug);
  % ueq3 = 0.5; 
   Lobsmc = L;
   Pobsmc = P;
   Wobsmc = W;
end
