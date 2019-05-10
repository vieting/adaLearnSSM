% Author: Peter Vieting

function [ ] = savelearning( filename, alg, Ahat, t, add_var )
%SAVELEARNING Saves learning variables during parfor execution

Ahat_name = ['Ahat_',alg];
Ahat_struct.(Ahat_name) = Ahat;
save(filename,'-struct','Ahat_struct');
save(filename,'t','-append');

if exist('add_var','var')
    switch alg
        case {'GDF','GDI'}
            e_name = ['e_',alg];
            e_struct.(e_name) = add_var;
            save(filename,'-struct','e_struct','-append');
        case {'DGD','VSS'}
            trig_name = ['trig_t_',alg];
            trig_struct.(trig_name) = add_var;
            save(filename,'-struct','trig_struct','-append');
    end
end

end
