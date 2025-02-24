function vary_sample_years

% Test for the effect of varying the fixed value of F being estimated

% Specify details of the run
SY = [3,6,9,12,15]; % target years of data
Fmu = [0.1,0.2];
Fcv = 0; 
Nsims = 100;
Site = 'Null';
Type = 'Mock';
Date = '14Jan2020';

Species = {'SMYS'};
       
%Fcvs = {0.5,0.5};

%NNsims = {5:10,10};
       
% Loop over species
%parpool(2)
%parfor s = 1:length(Species)
    s = 1;
    meta_fname = IPM_parameters(Species{s},Type,Site,Date,'lognormal');
   % Fcv = Fcvs{s};
    for f = 1:length(Fmu)
        % simulate data

    for ss = 1:length(SY)
        
            rockfish_mockdata(Nsims,meta_fname,Fmu(f),Fmu(f),9,SY(ss),1,...
            strcat(Species{s},'_mockdata_F',num2str(Fmu(f)),'_Fcv',num2str(Fcv),'_SY',num2str(SY(ss)),'_',Date),'mockdata_sampleyears',Fcv)


     %   Nsims_tmp = Nsims;
      %  Nsims_tmp = Nsims_tmp(f,:);
        % estimate F
        for j = 1:Nsims
            M = load(meta_fname,'Meta');
            Meta = M.Meta;
            Meta.data_savename = strcat('mockdata_sampleyears/',Species{s},'_mockdata_F',num2str(Fmu),'_Fcv',num2str(Fcv),'_SY',num2str(SY(ss)),'_',Date,'_R',num2str(j),'.mat');
            
            Meta.fit_savename = strcat('mockfits/',Species{s},'_Mock_fit_F',num2str(Fmu),'_Fcv',num2str(Fcv),'_SY',num2str(SY(ss)),'_',Date,'_R',num2str(j),'.mat');
            rockfish_fit_pisco_mock(Meta,0,SS(ss))
            end % end loop over sample size
            
        end % end loop over Nsims
        
    end % end loop over SY
    end % end loop over Fcv
    
%end % end parfor Species loop