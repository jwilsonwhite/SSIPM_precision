function vary_F 

% Test for the effect of varying the fixed value of F being estimated

% Specify details of the run
Fmu = 0:0.05:0.25;
Fcv = 0; 
Nsims = 10;
Site = 'Null';
Type = 'Mock';
Date = '14Jan2020';

Species = {'SMYS','SMEL','SATR','SCAR','SCAU','SFLA','SMIN','SAUR',...
            'OELO','PCLA','SCHR','SNEB','HDEC','SPAU','SMAR','SGUT','SSER','STRFRAAD'};
       
%Fcvs = {0.5,0.5};

%NNsims = {5:10,10};
       
% Loop over species
parpool(2)
parfor s = 1:length(Species)
    meta_fname = IPM_parameters(Species{s},Type,Site,Date,'lognormal');
   % Fcv = Fcvs{s};
    for f = 1:length(Fmu)
        % simulate data
        rockfish_mockdata(Nsims,meta_fname,Fmu(f),Fmu(f),9,9,1,...
            strcat(Species{s},'_mockdata_F',num2str(Fmu(f)),'_Fcv',num2str(Fcv),'_',Date),'mockdata',Fcv)

     %   Nsims_tmp = Nsims;
      %  Nsims_tmp = Nsims_tmp(f,:);
        % estimate F
        for j = 1:Nsims
            M = load(meta_fname,'Meta');
            Meta = M.Meta;
            Meta.data_savename = strcat('mockdata/',Species{s},'_mockdata_F',num2str(Fmu),'_Fcv',num2str(Fcv),'_',Date,'_R',num2str(j),'.mat');
            Meta.fit_savename = strcat('mockfits/',Species{s},'_Mock_fit_F',num2str(Fmu),'_Fcv',num2str(Fcv),'_',Date,'_R',num2str(j),'.mat');
            rockfish_fit_pisco_mock(Meta,0)
            
        end % end loop over Nsims
        
    end % end loop over Fcv
    
end % end parfor Species loop