function install_metismex()
%INSTALL_METISMEX install METIS and METISMEX interface for graph partitioning.
%
%   Requires: CMAKE and GIT
%
%   For further details see:
%   https://github.com/dgleich/metismex
%
%   Author: F. Negri (federico.negri@epfl.ch) 2013-2015
%   Copyright (C) Federico Negri, CMCS, EPFL


reply = input('\nDid you already install CMAKE? \n(check by typing ''cmake --version'' in a terminal) Y/N:','s');
if isempty(reply)
    reply = 'N';
end

if strcmp(reply,'N')
   fprintf('\nPlease install CMAKE before continuing.')
   fprintf('\n\nOn Linux: sudo apt-get install cmake')
   fprintf('\nOn Mac OSX: if you have XCode, go to preferences --> downloads --> command line tools')
   fprintf('\n\nPress Enter to continue\n')
   pause()
end


%% Download METIS
url_metis = 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.0.2.tar.gz';

fprintf('Download and untar metis-5.0.2 from\n%s\n...\n',url_metis);

untar(url_metis);

cd metis-5.0.2

% fix file include/metis.h for 64bit arch.
if ~isempty(regexp(computer('arch'),'64'))
    
    fprintf('64 bit architecture detected: modify the file /include/metis.h\n');
    
    A     = regexp( fileread('include/metis.h'), '\n', 'split');
    copyfile('include/metis.h','include/metis_backup.h');
    
    A{33} = sprintf('%s','#define IDXTYPEWIDTH 64');
    
    fid   = fopen('include/metis.h', 'w');
    fprintf(fid, '%s\n', A{:});
    fclose(fid);
    
end

%% Ask user to open a terminal and run cmake
path_terminal = pwd;
fprintf('\n*****************************************************\n');
fprintf('ATTENTION: please open a terminal and type:\n%s\n',['cd ',path_terminal]);
fprintf('\nThen run the following commands (requires CMAKE!):\n')
fprintf('\nmake config\n')
fprintf('make all\n')

reply2 = input('\nDid you succeed? Y/N:','s');
if isempty(reply2)
    reply2 = 'N';
end

if strcmp(reply2,'Y')
    
    %% download and install metismex
    fprintf('\nDownload metismex from git://github.com/dgleich/metismex.git (requires GIT!) ...')
    system('git clone git://github.com/dgleich/metismex.git');
    cd metismex
    
    fprintf('\nCompile metismex ...')
    make
    
    fprintf('\nFinished!\n')
    cd ../../
else
    cd ..
    fprintf('\nAborted, try again.\n')
    
end
