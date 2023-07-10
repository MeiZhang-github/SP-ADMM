function [num,PP, dd, Connect_Mat] = Generate_network(anchor, n_fix, CommRange, n_scale)


m = size(anchor,1);
Connect_Mat = zeros(n_fix);
num=0;

while any(sum(Connect_Mat~=0)>2 == 0) % ÿ��agent������3���ڵ�������Connect_Mat�ĵ�i�г��Խ�����������3������Ԫ��
    
    agent = n_scale.*rand(n_fix, 2);
    PP = [agent; anchor]';
    
    %% dd <-- the matrix of true distance 
    
    Dist_Mat = zeros(n_fix+m, n_fix+m);
    for i = 1:n_fix+m
        Diff = repmat(PP(:, i), 1, n_fix+m) - PP(:, :);  %Diff�ɾ���PP(:, i)���Ƴ�1*��n_fix+m����ƽ�̶���
        Dist_i2All = sqrt(diag(Diff'*Diff));
        Dist_Mat(i, :) = Dist_i2All; % ��i��������ڵ�ľ��룬 Dist_Mat�ĶԽ���ΪȫΪ0
    end
    
    Connect_Mat = (Dist_Mat<=CommRange); % С�ڵ���CommRange��Ϊ1������Ϊ0
    Connect_Mat = Connect_Mat - eye(m+n_fix); % Connect_Mat�Խ���ȫΪ0
    num=num+1;
end
dd = Dist_Mat.*Connect_Mat;