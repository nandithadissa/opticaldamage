function [] = setnd2( pos )
%Set the Position of ND2 on Optic Bench 1
%   This compares pos to the possible values for nd2 as set in the variable
%   nd2s. To change potential ND2 positions, change nd2s in initiatebench1.
global nd2 fromgui
if fromgui == 1
    probe()
end
global nd2s
if ischar(pos)
    if strcmpi(pos,nd2s{1})
        fprintf(nd2,'pos=1');
        fscanf(nd2);
    elseif strcmpi(pos,nd2s{2})
        fprintf(nd2,'pos=2');
        fscanf(nd2);
    elseif strcmpi(pos,nd2s{3})
        fprintf(nd2,'pos=3');
        fscanf(nd2);
    elseif strcmpi(pos,nd2s{4})
        fprintf(nd2,'pos=4');
        fscanf(nd2);
    elseif strcmpi(pos,nd2s{5})
        fprintf(nd2,'pos=5');
        fscanf(nd2);
    elseif strcmpi(pos,nd2s{6})
        fprintf(nd2,'pos=6');
        fscanf(nd2);
    else
        error('Invalid value for nd1.')
    end
elseif isnumeric(pos)
    if pos == nd2s{1}
        fprintf(nd2,'pos=1');
        fscanf(nd2);
    elseif pos == nd2s{2}
        fprintf(nd2,'pos=2');
        fscanf(nd2);
    elseif pos == nd2s{3}
        fprintf(nd2,'pos=3');
        fscanf(nd2);
    elseif pos == nd2s{4}
        fprintf(nd2,'pos=4');
        fscanf(nd2);
    elseif pos == nd2s{5}
        fprintf(nd2,'pos=5');
        fscanf(nd2);
    elseif pos == nd2s{6}
        fprintf(nd2,'pos=6');
        fscanf(nd2);
    else
        error('Invalid value for nd1.')
    end
else
    error('Invalid type for nd1.')
end
if fromgui == 1
    probe()
end
end