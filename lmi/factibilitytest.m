function plotfactibility(paraminterval, lmiparam, lmifunction,varargin)
    % ***   AN�LISE DE ESTABILIDADE - FUZZY LYAPUNOV FUNCTION   ***
    % *************************************************************
    %           VERIFICANDO A REGI�O DE ESTABILIDADE
    % *************************************************************
    % Este exemplo � uma altera��o do Exemplo 5 (p�g. 2789) do Artigo:
    % A membership-function-dependent approach for stability analysis and
    % controller synthesis of Takagi�Sugeno models
    % Miguel Bernal, Thierry M. Guerra, Alexandre Kruszewskic, 2009.
    % -------------------------------------------------------------------
    p = inputParser;
    lmivars = p.Results;

    % PAR�METROS DO PROBLEMA
    p = 2; ri = 2^p;
     % ----------------------------------------------------------------------
    % % Intervalo de estudo
    alim = [1 6];
    blim = [-1.5 1.5];

    figure(1)
    hold on
    xlabel('a1')
    ylabel('a2')

    for a1 = alim(1):(alim(2) - alim(1)) / 5:alim(2)

        for a2 = blim(1):(blim(2) - blim(1)) / 5:blim(2)
            % for a1=alim(1):0.25:alim(2)
            %     for a2=blim(1):0.25:blim(2)
            K = lmifunction(lmivars{:});

            if ~isempty(K)
                plot(a1, a2, 'kx', 'MarkerSize', 10);
            end

            % ----------------------------------------------------------
        end

    end

    hold off;

    f1Leg = legend('figure(1)');
    set(f1Leg, 'visible', 'off')

 %   matlab2tikz('figure1.tex')
end
