function [fullCtrb,A,B,P]= isctrbslslmi2(Asigma, Bsigma)
    %function [AsigmaLambda,alamb] = isobsvslslmi(Asigma, Csigma)
        %%TEST IF A SWITCHED LINEAR SYSTEM IS OBSERVABLE through the
        %%observability of the global system, or the convex combination.
        %%Requires a convex set
        %Returns the observability matrix, rank and a boolean if system is
        %Controllable

        %Tests locally   - P common
        [rA,~] = size(Asigma{1,1});
        tol = 1E-7;
        ops = sdpsettings('solver','sedumi','verbose',0,'debug',0,'showprogress',0);
        P = sdpvar(rA,rA);
  
        %Controllability restricion
        function rest = rest(A,B)
            rest = [A*P+P*A'-B*B'<=-tol];
        end
    
        restr =  cellfun(@(A,B) rest(A,B),Asigma,Bsigma,...
            'UniformOutput',false);
        
        lmiRestr = [P>=tol,restr{:}];   
        
        [fullCtrb,P] = solvelmi(P,lmiRestr,[],ops,'Controllable');

        
end

