% nf_all = 0.1
function dd_errork = generate_noise(dd0, nf_all, noisetype)

if numel(nf_all) == 1 % Returns the number of non-zero elements
    nf = nf_all;
elseif numel(nf_all) == 2
    mu = nf_all(1);
    nf = nf_all(2);
end

% for t = 1:2
% 
%     if t == 1
        dd = dd0;
%     else
%         dd = dd_sf;
%     end

    dd_tril = tril(dd); % dd ����������Ǿ���,����Ԫ�ز�0��

%     Connect_Idx = find(dd);
    Connect_dd_tril_Idx = find(dd_tril); % ���н�������ֱ�����������в�Ϊ��Ԫ�ص����
    N_Idx = length(Connect_dd_tril_Idx); % ���������з���Ԫ�صĸ�����Ҳ���� �� �ĸ���

    dd_error_1 = dd; % dd:��ʵ�ľ������
%     noise = zeros(size(dd));

    switch noisetype
        case 'interval'
            noise_Vec = nf*(rand(N_Idx, 1)-0.5);
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx) + noise_Vec;
        case 'additive normal'
            % noise(Connect_dd_tril_Idx) = noise_Vec;
            noise_Vec = nf*randn(N_Idx, 1); % ����������������0.1*��׼��̬�ֲ�������N(0,0.01)��̬�ֲ�
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx) + noise_Vec; % �����ӵĽڵ����ʵ����Ӹ�˹��������
        case 'Gaussian: non-zero mean'
            noise_Vec = mu + nf*randn(N_Idx, 1);
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx) + noise_Vec;
        case 'half normal'
            % noise(Connect_dd_tril_Idx) = noise_Vec;
            noise_Vec = nf*randn(N_Idx, 1);
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx) + abs(noise_Vec);        
        case 'additive Laplacian'
            UnifRnd = rand(N_Idx, 1) - 0.5;
            noise_Vec = nf*sign(UnifRnd).*log(1-2*abs(UnifRnd));
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx) + noise_Vec;
        case 'multiplicative'        
            noise_Vec = nf*randn(N_Idx, 1);
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx).*(1+ noise_Vec);
        case 'log-normal'
            noise_Vec = nf*randn(N_Idx, 1);
            dd_error_1(Connect_dd_tril_Idx) = dd_error_1(Connect_dd_tril_Idx).*10.^noise_Vec;
    end

    dd_error = tril(dd_error_1) + tril(dd_error_1)';
    dd_error = abs(dd_error);
%     if t == 2   
%         dd_sf_error = dd_error;
%     else
        dd_errork = dd_error;
%     end
% end