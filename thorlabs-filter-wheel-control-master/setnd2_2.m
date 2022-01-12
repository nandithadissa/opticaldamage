function [] = setnd2_2( pos )
%Set the Position of ND2 on Optic Bench 1
global nd2_2 fromgui nd2s_2
if fromgui == 1
    probe_2()
end
if ischar(pos)
    if strcmp(pos,nd2s_2{1})
        fprintf(nd2_2,'pos=1');
        fscanf(nd2_2);
    elseif strcmp(pos,nd2s_2{2})
        fprintf(nd2_2,'pos=2');
        fscanf(nd2_2);
    elseif strcmp(pos,nd2s_2{3})
        fprintf(nd2_2,'pos=3');
        fscanf(nd2_2);
    elseif strcmp(pos,nd1s_2{4})
        fprintf(nd2_2,'pos=4');
        fscanf(nd2_2);
    elseif strcmp(pos,nd2s_2{5})
        fprintf(nd2_2,'pos=5');
        fscanf(nd2_2);
    elseif strcmp(pos,nd2s_2{6})
        fprintf(nd2_2,'pos=6');
        fscanf(nd2_2);
    else
        error('Invalid value for Bench 2 ND2.')
    end
elseif isnumeric(pos)
    if pos == nd2s_2{1}
        fprintf(nd2_2,'pos=1');
        fscanf(nd2_2);
    elseif pos == nd2s_2{2}
        fprintf(nd2_2,'pos=2');
        fscanf(nd2_2);
    elseif pos == nd2s_2{3}
        fprintf(nd2_2,'pos=3');
        fscanf(nd2_2);
    elseif pos == nd2s_2{4}
        fprintf(nd2_2,'pos=4');
        fscanf(nd2_2);
    elseif pos == nd2s_2{5}
        fprintf(nd2_2,'pos=5');
        fscanf(nd2_2);
    elseif pos == nd2s_2{6}
        fprintf(nd2_2,'pos=6');
    else
        error('Invalid value for Bench 2 ND2.')
    end
else
    error('Invalid input type for Bench 2 ND2.')
end
if fromgui == 1
    probe_2()
end
end

