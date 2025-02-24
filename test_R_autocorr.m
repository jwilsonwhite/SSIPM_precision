function test_R_autocorr 

% Test for bias and precision in estimating F when R is autocorrelated

% Specify details of the run
Fmu = 0.1;
Fcv = 0;
Rcorr = [0 0.1 0.5];
Rsd = [0.1 1.0];
Nsims = 10;
Site = 'Null';
Type = 'Mock';
Date = '3Feb2025';

Species = {'SMYS'};
       
% Loop over species
s = 1;% :length(Species)
    meta_fname = IPM_parameters(Species{s},Type,Site,Date,'lognormal');
    
    for f = 1:length(Rsd)
        for r = 1:length(Rcorr)

        %%% ADD THE TWO NEW PARAMETERS...
        % Do they go in Meta and then pass to rockfish_mockdata?
        % Then need to add a switch to make sure the old version is
        % grandfathered in
        % ALSO CHECK VALUES TO USE....% AND SUMMARY STATS TO CALCULATE

        % simulate data
        rockfish_mockdata(Nsims,meta_fname,Fmu,Fmu,9,9,1,...
            strcat(Species{s},'_mockdata_F',num2str(Fmu),'_Fcv',num2str(Fcv),'_Rsd',num2str(Rsd(f)),'_Rcorr',num2str(Rcorr(r)),'_',Date),'mockdata',Fcv,Rsd(f),Rcorr(r))

       % Nsims_tmp = NNsims{s};
       % Nsims_tmp = Nsims_tmp(f,:);
        % estimate F
        for j = 1:Nsims
            M = load(meta_fname,'Meta');
            Meta = M.Meta;
            Meta.data_savename = strcat('mockdata/',Species{s},'_mockdata_F',num2str(Fmu),'_Fcv',num2str(Fcv),'_Rsd',num2str(Rsd(f)),'_Rcorr',num2str(Rcorr(r)),'_',Date,'_R',num2str(j),'.mat');
            Meta.fit_savename = strcat('mockfits/',Species{s},'_Mock_fit_F',num2str(Fmu),'_Fcv',num2str(Fcv),'_Rsd',num2str(Rsd(f)),'_Rcorr',num2str(Rcorr(r)),'_',Date,'_R',num2str(j),'.mat');
            rockfish_fit_pisco_mock(Meta,0)
            
        end % end loop over Nsims
        
    end % end loop over Rcorr
    
    end % end loop over Rsd