function [V,I,res] = findBasis(Csigma)
    %Solution is so conservative. Ideally V is nonsingular, but some
    %adaptations was made.
    %Return the new basis V for C_1V = C2_v = ... = [0 I]
    
    [rC,cC] = size(Csigma{1,1}); %Number of rows and columns
    h = cC - rC; %Number of lost sensors
    I = [zeros(rC,h),eye(rC)];
    I_2 = [eye(rC), zeros(rC,h)];
    ops = sdpsettings('solver','sedumi','verbose',0,'debug',0,'showprogress',0,...
                'warning',0);
    
    %Solver not identified
    ops2 = sdpsettings('verbose',0,'debug',0,'showprogress',0,...
            'warning',0);
    %Make all the multiplications C_i*V, jump this step if C_i = [0 I]
    equality = cellfun(@(x) isequal(x,I),Csigma,'UniformOutput',false);
    equality_2 = cellfun(@(x) isequal(x,I_2),Csigma,'UniformOutput',false);
    
    if all(cell2mat(equality))
        V = eye(cC,cC);
        return;       
    end
    
    %Hard Coded - Propose something to invert the order of rows
    if all(cell2mat(equality_2))
        V = [0,1;1,0];
        return;       
    end
    
    
    
    V = sdpvar(cC,cC,'full');
    tol = 1E-5;
    %opts=sdpsettings('solver','sedumi','verbose',0);
    multiCell = cellfun(@(x) x*V, Csigma, 'UniformOutput',false);
    rest = cellfun(@(x) [x-I>= -tol, x-I<= tol],multiCell,'UniformOutput',false);
    res = optimize([det(V) >=tol, rest{:}],[],ops);

    if res.problem == 0
        V = value(V);
    else
        res = optimize([det(V)<=-tol,rest{:}],[],ops2);
        if res.problem == 0
            V = value(V);
        else
            V = zeros(cC,cC);
            disp('There is no feasible solution');
        end
    end
end
