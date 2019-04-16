classdef Sperm_T2 < ASRT2.ASRT2
    %Detector
    properties
        name = 'SPRM_CRA_V01'
        spec_name = 'sperm'
        initialized = false
        version = '1.0'
    end
    methods
        function d = Sperm_T2(det)  % Usual constructor
            
            
            d@ASRT2.ASRT2(det);  % setup generic ASR properties, call ASR.m

            %*****************
            d.score = 0.8;
            %*****************
            
            d.parm.profile = 'GoMex';
            d.parm.type = 'SPRM_CRA_V01-Sperm-Clicks';
            d.parm.thold = d.score;
            [~, d.parm] = SegReco.iNed.iNED_Init_Species(d.name, d.parm);
            
            d.AlgObj = SegReco.ASR_T2.Initilize_Species(d.AlgObj,d.label,d.parm);
            d.initialized = true;            
            d.ReSample = d.AlgObj.Pre_Processing.resample.enable; %just a flag            
            if ~d.ReSample
                d.SampleRate = det.ChanMode.JobSndTbl.FileSig{1}.sampleRate;    
            end
                           
            [d.AlgObj, signal,Fs ] = SegReco.DetectionProcessing.Filter_signal(d.AlgObj,[],d.SampleRate, 'design');

            % flags control
            d.AlgObj.Finalize.EventPerClick = false;            
            d.AlgObj.Feature.Extraction.Train = false;
            d.AlgObj.Feature.Extraction.enable = false;
            
            
        end
        
        % resample method, apply for non matching sound rates between archive and detector.
        
        
        
        
    end % methods
end % classdef