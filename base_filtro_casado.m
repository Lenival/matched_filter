
%bits = [1 2 3 -3 -2 -1 2 -1 2 1 -2];         % Stream de bits
%dim = 4; bits = reshape(randi([-3,3],dim),[1,dim^2]);       % Stream de bits aleatórios
l_m = 100;               % Comprimento da mensagem
m_tx = (-1).^(round(rand(1,l_m))).*randi([1,3],1,l_m);       % Mensagem

% Parâmetros do cosseno levantado
sps = 4;                         % Quantidade de amostras/período
span = 6;                        % Quantidade de zeros
beta = 0.5;                      % Fator de roll-off
T = 1+span*sps;                  % Largura do pulso em amostras
N0 = 1.5;                          % Potência do ruído

up_bits = upsample(m_tx,T);      % Upsample da mensagem

l_t = length(up_bits);

t = 0:(l_t-1);

% Definição do formatos de pulsos
sw = 1*ones(1,T);               % Janela retangular
%sw = 2*rcosdesign(beta,span,sps);       % Cosseno levantado


% Criação do sinal transmitido
sinal = conv(up_bits,sw);
sinal = sinal(1:l_t);
%sinal = sinal(T:end);
%stem(t,sinal)


% Criação do ruído de canal
n = N0*randn(1,l_t);

% Sinal recebido
r = sinal+n;
%r = [zeros(1,10) r(1:l_t-10)];         % Causando atrado de 10 amostras

% Sinal filtrado
mf = flip(sw);

% Vetor de bits estimados
Y_i = [];

% Mensagem detectada
m_rx = [];

% Vetor de amplitudes médias para comparação
Y_mean = [];

for k = 1:1:l_m
    %[((k-1)*T+1) k*T]
    %r(((k-1)*T+1),k*T)
    Y_temp = 0;
    Y_temp = (1/T)*conv(r(((k-1)*T+1):k*T),mf);
    Y_i = [Y_i Y_temp(1:T)];
    m_rx = [m_rx  round(Y_temp(T))];
    % Calculando o valor médio de cada bit para fazer a comparação
    % Y_mean = [Y_mean ones(1,T).*mean(r(((k-1)*T+1):k*T))];
    %Y = (1/T)*conv(r,mf);
end

%Y = (1/T)*conv(r,mf);
%Y = Y(1:l_t);

% Vetor de mensagens erradas
error = (m_tx-m_rx)~=0;

% Taxa de erro de bits
ber = sum(error)/l_m

figure;
hold on
stem(t,Y_i,'m')
stem(t,sinal,'c')
stem(t,r,'g')
%subplot(2,2,1)
%stem(t,sinal,'c')
%subplot(2,2,2)
%stem(t,n,'c')
%subplot(2,2,3)
%stem(t,r,'g')
%subplot(2,2,4)
%stem(t,Y_i,'m')

hold off