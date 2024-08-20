function process_error_F 

% Test for bias and precision in estimating F when F has process error too

% Specify details of the run
Fmu = 0.1;
%Fcv = 0:0.1:0.5;
Nsims = 10;
Site = 'Null';
Type = 'Mock';
Date = '14Jan2020';

Species = {'SSER','STRFRAAD'};
       
Fcvs = {0.5,0.5};

NNsims = {5:10,10};
       
% Loop over species
parpool(2)
parfor s = 1:length(Species)
    meta_fname = IPM_parameters(Species{s},Type,Site,Date,'lognormal');
    Fcv = Fcvs{s};
    for f = 1:length(Fcv)
        % simulate data
        rockfish_mockdata(Nsims,meta_fname,Fmu,Fmu,9,9,1,...
            strcat(Species{s},'_mockdata_F',num2str(Fmu),'_Fcv',num2str(Fcv(f)),'_',Date),'mockdata',Fcv(f))

        Nsims_tmp = NNsims{s};
        Nsims_tmp = Nsims_tmp(f,:);
        % estimate F
        for j = 1:length(Nsims_tmp)
            M = load(meta_fname,'Meta');
            Meta = M.Meta;
            Meta.data_savename = strcat('mockdata/',Species{s},'_mockdata_F',num2str(Fmu),'_Fcv',num2str(Fcv(f)),'_',Date,'_R',num2str(Nsims_tmp(j)),'.mat');
            Meta.fit_savename = strcat('mockfits/',Species{s},'_Mock_fit_F',num2str(Fmu),'_Fcv',num2str(Fcv(f)),'_',Date,'_R',num2str(Nsims_tmp(j)),'.mat');
            rockfish_fit_pisco_mock(Meta,0)
            
        end % end loop over Nsims
        
    end % end loop over Fcv
    
end % end parfor Species loop