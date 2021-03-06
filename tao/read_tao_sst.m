function t=read_tao_sst(fname)
% read_tao_t.m
% create mat files from fixed depth subsurface temperature data
% $Revision: 1.1 $ $Date: 2011/07/29 23:31:56 $ $Author: aperlin $	
% Originally A. Perlin
fid=fopen(fname,'r');
qlt=strvcat('Quality Code Definitions:',...
'0 = datum missing',...
'1 = highest quality; Pre/post-deployment calibrations agree to within',...
'sensor specifications.  In most cases only pre-deployment calibrations have',...
'been applied',...
'2 = default quality; Pre-deployment calibrations applied.  Default',...
'value for sensors presently deployed and for sensors which were either not',...
'recovered or not calibratable when recovered.',...
'3 = adjusted data; Pre/post calibrations differ, or original data do',...
'not agree with other data sources (e.g., other in situ data or climatology),',...
'or original data are noisy.  Data have been adjusted in an attempt to',...
'reduce the error.',...
'4 = lower quality; Pre/post calibrations differ, or data do not agree',...
'with other data sources (e.g., other in situ data or climatology), or data',...
'are noisy.  Data could not be confidently adjusted to correct for error.',...
'5 = sensor or tube failed');
srs=strvcat('Source code definitions:',...
'    0 - No Sensor, No Data ',...
'    1 - Real Time (Telemetered Mode)',...
'    2 - Derived from Real Time',...
'    3 - Temporally Interpolated from Real Time',...
'    4 - Source Code Inactive at Present',...
'    5 - Recovered from Instrument RAM (Delayed Mode)',...
'    6 - Derived from RAM',...
'    7 - Temporally Interpolated from RAM');
dd=textscan(fid,'%s',2,'delimiter','\r\n');
a=char(dd{:});
ik=find(a(1,:)=='(');
t.readme=strvcat('Sea Surface Temperatures',' ',a(1,1:ik-1),' ',qlt,srs);
ik=find(a(1,:)==',');
nblocks=str2num(a(1,ik(1)+1:ik(1)+4));
for i=1:nblocks
   dd=textscan(fid,'%s',3,'delimiter','\r\n');
   a=char(dd{:});
   ik=find(a(1,:)==',');
   nlines=str2num(a(1,ik(1)+1:end-6));
   ikk=find(a(2,:)=='Q');
   tmp=textscan(fid,['%s %s %f %s %s'],nlines);
   t(i).time=datenum([char(tmp{1}) char(tmp{2})],'yyyymmddHHMM');
   t(i).SST(:,1)=tmp{3};
   t(i).quality=tmp{end-1};
   t(i).source=tmp{end};
   bad=find(t(i).SST<-9);
   t(i).SST(bad)=NaN;
   dd=textscan(fid,'%s',1,'delimiter','\r\n');
end
fclose(fid);
id=find(fname=='.');
save(fname(1:id-1),'t')


